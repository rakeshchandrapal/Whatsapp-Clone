import 'package:flutter/material.dart';
import 'package:whatsapp_clone/assets/colors.dart';

import '../../assets/info.dart';
import '../appText.dart';

class WebChatAppBar extends StatelessWidget {
  const WebChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height*0.077,
      width: MediaQuery.of(context).size.width*0.70,
      padding: const EdgeInsets.all(10),
      color: webAppBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://uploads.dailydot.com/2018/10/olli-the-polite-cat.jpg?auto=compress%2Cformat&ixlib=php-3.3.0.jpg'),
                radius: 30,
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.01),
              AppText(text:info[0]['name'].toString(),size: 18,),

            ],
          ),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search),color: Colors.grey,),
              IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz),color: Colors.grey,),
            ],
          ),

        ],
      ),
    );
  }
}