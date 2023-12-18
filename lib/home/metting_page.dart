import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import 'bottom_view.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> implements HMSUpdateListener, HMSPreviewListener, HMSActionResultListener {
  //SDK
  late HMSSDK hmsSDK;
  List<HMSVideoTrack> videoTracks = [];
  bool isMicOff = true;
  bool isCameraOff = true;
  bool displayMicrophoneButton = true;
  // Variables required for joining a room
  String authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJzaW9uIjoyLCJ0eXBlIjoiYXBwIiwiYXBwX2RhdGEiOm51bGwsImFjY2Vzc19rZXkiOiI2NTdmZDNkZTkyOTYxM2FkNTdiNjRmYzQiLCJyb2xlIjoiaG9zdCIsInJvb21faWQiOiI2NTdmZDNlODM0MTJkMTkzZTg0MjAxZjYiLCJ1c2VyX2lkIjoiM2NkOWFhNjAtOGFiNi00NWI1LTgwNzYtN2Q0NThjYzVkNjI3IiwiZXhwIjoxNzAyOTYyNTk4LCJqdGkiOiI3YmMwMTAzZC0xNDk3LTQxODMtOTFhNi1hOTY5ZWExMjUyNjYiLCJpYXQiOjE3MDI4NzYxOTgsImlzcyI6IjY1N2ZkM2RlOTI5NjEzYWQ1N2I2NGZjMiIsIm5iZiI6MTcwMjg3NjE5OCwic3ViIjoiYXBpIn0.uNGkBueeXnEKoRxf6dFc1O8kKaHSKbl-f80N-63Qa3E';
  String userName = "host_user";

  // Variables required for rendering video and peer info
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;

  // Initialize variables and join room
  @override
  void initState() {
    super.initState();
    initHMSSDK();
  }

  void initHMSSDK() async {
    hmsSDK = HMSSDK();
    await hmsSDK.build(); // ensure to await while invoking the `build` method
    hmsSDK.addUpdateListener(listener: this);
    hmsSDK.join(config: HMSConfig(authToken: authToken, userName: userName));
    hmsSDK.addPreviewListener(listener:this);
    hmsSDK.preview(config: HMSConfig(authToken: authToken, userName: userName));
    /// To switch local peer's audio on/off.
  }

  // Clear all variables
  @override
  void dispose() {
    remotePeer = null;
    remotePeerVideoTrack = null;
    localPeer = null;
    localPeerVideoTrack = null;
    super.dispose();
  }

  // Called when peer joined the room - get current state of room by using HMSRoom obj
  @override
  void onJoin({required HMSRoom room}) {
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        localPeer = peer;
        if (peer.videoTrack != null) {
          localPeerVideoTrack = peer.videoTrack;
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }


  // Called when there's a peer update - use to update local & remote peer variables
  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (!peer.isLocal) {
          if (mounted) {
            setState(() {
              remotePeer = peer;
            });
          }
        }
        break;
      case HMSPeerUpdate.peerLeft:
        if (!peer.isLocal) {
          if (mounted) {
            setState(() {
              remotePeer = null;
            });
          }
        }
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        return;
      default:
        if (mounted) {
          setState(() {
            localPeer = null;
          });
        }
    }
  }

  // Called when there's a track update - use to update local & remote track variables
  @override
  void onTrackUpdate(
      {required HMSTrack track,
        required HMSTrackUpdate trackUpdate,
        required HMSPeer peer}) {
    //To check mute/unmute status for local peer
    if (peer.isLocal) {
      if (track.kind == HMSTrackKind.kHMSTrackKindAudio &&
          track.source == "REGULAR") {
        isMicOff = track.isMute;
      }
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo &&
          track.source == "REGULAR") {
        isCameraOff = track.isMute;
      }

      //Checking whether peer is local or not
      if (peer.isLocal) {
        if(peer.role.publishSettings?.allowed.contains("audio")??false){
          displayMicrophoneButton = true;
        }
        else{
          displayMicrophoneButton = false;
        }
      }

    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      switch (trackUpdate) {
        case HMSTrackUpdate.trackRemoved:
          if (mounted) {
            setState(() {
              peer.isLocal
                  ? localPeerVideoTrack = null
                  : remotePeerVideoTrack = null;
            });
          }
          return;
        default:
          if (mounted) {
            setState(() {
              peer.isLocal
                  ? localPeerVideoTrack = track as HMSVideoTrack
                  : remotePeerVideoTrack = track as HMSVideoTrack;
            });
          }
      }
    }
  }
}
  Widget peerTile(Key key, HMSVideoTrack? videoTrack, HMSPeer? peer) {
    return Container(
      key: key,
      child: (videoTrack != null && !(videoTrack.isMute))
      // Actual widget to render video
          ? HMSVideoView(
        track: videoTrack,
      )
          : Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(4),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.blue,
                blurRadius: 20.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: Text(
            peer?.name.substring(0, 1) ?? "D",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      // Used to call "leave room" upon clicking back button [in android]
      onWillPop: () async {
        hmsSDK.leave();
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          bottomNavigationBar: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).hintColor,
                  blurRadius: .5,
                  spreadRadius: .1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    isMicOff = !isMicOff;
                    hmsSDK.toggleMicMuteState();
                    setState(() {

                    });
                    // hmsSDK.leave();
                    // Navigator.pop(context);
                  },
                  elevation: 2.0,
                  fillColor: isMicOff?Colors.red:Colors.green,
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child:  Icon(isMicOff?Icons.mic_off:Icons.mic,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    isCameraOff = !isCameraOff;
                    hmsSDK.toggleCameraMuteState();
                    setState(() {

                    });
                    // hmsSDK.leave();
                    // Navigator.pop(context);
                  },
                  elevation: 2.0,
                  fillColor: isMicOff?Colors.red:Colors.green,
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child:  Icon(isCameraOff?Icons.videocam_off:Icons.video_call,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    hmsSDK.leave();
                    Navigator.pop(context);
                  },
                  elevation: 2.0,
                  fillColor: Colors.red,
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.call_end,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    showTopSheet(context);
                    // hmsSDK.leave();
                    // Navigator.pop(context);
                  },
                  elevation: 2.0,
                  fillColor: Colors.blue,
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child:  Icon(Icons.more_vert_rounded,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              // Grid of peer tiles
              Container(
                height: MediaQuery.of(context).size.height,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: (remotePeerVideoTrack == null)
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.height / 2,
                      crossAxisCount: 1),
                  children: [
                    if (remotePeerVideoTrack != null && remotePeer != null)
                      peerTile(
                          Key(remotePeerVideoTrack?.trackId ?? "" "mainVideo"),
                          remotePeerVideoTrack,
                          remotePeer),
                    peerTile(
                        Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                        localPeerVideoTrack,
                        localPeer)
                  ],
                ),
              ),
              // End button to leave the roo
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onAudioDeviceChanged({HMSAudioDevice? currentAudioDevice, List<HMSAudioDevice>? availableAudioDevice}) {
    // TODO: implement onAudioDeviceChanged
  }

  @override
  void onChangeTrackStateRequest({required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onException({required HMSActionResultListenerMethod methodType, Map<String, dynamic>? arguments, required HMSException hmsException}) {
    // TODO: implement onException
  }

  @override
  void onHMSError({required HMSException error}) {
    // TODO: implement onHMSError
  }

  @override
  void onMessage({required HMSMessage message}) {
    // TODO: implement onMessage
  }

  @override
  void onPeerListUpdate({required List<HMSPeer> addedPeers, required List<HMSPeer> removedPeers}) {
    // TODO: implement onPeerListUpdate
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    // TODO: implement onPreview
    //videoTracks is the List<HMSVideoTrack> which we have set above
    HMSVideoView(
      scaleType:
      ScaleType.SCALE_ASPECT_FILL,
      track:videoTracks[0],//setting the first track from videoTracks list to render on screen
      setMirror: true,
    );
  }

  @override
  void onReconnected() {
    // TODO: implement onReconnected
  }

  @override
  void onReconnecting() {
    // TODO: implement onReconnecting
  }

  @override
  void onRemovedFromRoom({required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // TODO: implement onRemovedFromRoom
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    // TODO: implement onSessionStoreAvailable
  }

  @override
  void onSuccess({required HMSActionResultListenerMethod methodType, Map<String, dynamic>? arguments}) {
    // TODO: implement onSuccess
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker>

  updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }

  void showTopSheet(BuildContext context) {
    Widget content;

    content = GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MoreOptionBottomSheet());

    showModalBottomSheet(
        context: context,
        builder: (context) => content,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,// Set the height to cover half of the screen
    );
  }
}

