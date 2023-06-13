import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widgets/message_reply_preview.dart';

import '../../../assets/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _messageController = TextEditingController();
  bool isShowSendBtn = false;
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  FlutterSoundRecorder?  _soundRecorder;

  @override
  void initState() {
    super.initState();

    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Mic Permission is not allowed !');
    }
    else {
      await _soundRecorder!.openRecorder();
      isRecorderInit = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void hideEmojiContainer(){
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer(){
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer(){
    if(isShowEmojiContainer){
      showKeyboard();
      hideEmojiContainer();
    }
    else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void sendTextMessage() async {
    if (isShowSendBtn) {
      ref.read(chatControllerProvider).sendTextMessage(context,
          _messageController.text.trim().toString(), widget.receiverUserId);
      setState(() {
        _messageController.text = "";
      });
    }
    else{
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if(!isRecorderInit){
        return;
      }
      if(isRecording){
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      }
      else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }


  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode:  focusNode,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendBtn = true;
                    });
                  } else {
                    setState(() {
                      isShowSendBtn = false;
                    });
                  }
                },
                controller: _messageController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: mobileChatBoxColor,
                    prefixIcon: SizedBox(
                      width: 50,
                      child: IconButton(
                        onPressed: toggleEmojiKeyboardContainer,
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: selectVideo,
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 2.0,
                right: 2,
                left: 2,
              ),
              child: CircleAvatar(
                backgroundColor: tabColor,
                radius: 25,
                child: IconButton(
                        onPressed: sendTextMessage,
                        icon:  Icon( isShowSendBtn ? Icons.send : isRecording ? Icons.close : Icons.mic),
                        color: Colors.white,
                      )

              ),
            ),

          ],
        ),

        isShowEmojiContainer ?  SizedBox(height: 310,
          child: EmojiPicker(
            onEmojiSelected: ((category,emoji){
              setState(() {
                _messageController.text = _messageController.text+emoji.emoji;
              });

              if(!isShowSendBtn){
                setState(() {
                  isShowSendBtn  = true;
                });
              }
            }),
          ),
        ) : const SizedBox(),
      ],
    );
  }
}