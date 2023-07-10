import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeScreen extends StatefulWidget {
const AboutMeScreen({super.key});

@override
State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
@override
Widget build(BuildContext context) {
final wsize = MediaQuery.of(context).size.width;
return SafeArea(
  child: Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      title:const Text('About Me',style: TextStyle(fontSize: 20),),
      centerTitle: true,),

  body: SafeArea(
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          color: Colors.grey,
          padding:const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: wsize * 0.4,
                child: CircleAvatar(
                  radius: wsize * 0.4 -5,
                  backgroundImage: const AssetImage(
                    'assets/images/Aron.jpg')),
              ),
              const SizedBox(
                height:12,
                ),
                Text('Aron Jumawan',style: GoogleFonts.rubik(
                fontSize: 34,
                fontWeight: FontWeight.w600,
                ),
                ),
                const SizedBox(height: 12,),
    
              Row(
                children: const [
                    Text('Actively Looking', 
                    style: TextStyle(
                    fontSize: 22,
                  ),),
                  SizedBox(width: 12,),
    
                  FaIcon(FontAwesomeIcons.solidCircleCheck,color: Colors.black,),
    
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children:  [
                    const Text('Applied'),
                    Text('98',style: GoogleFonts.robotoCondensed(
                      fontSize: 25,
                    ),),
                  ],
                ),
                Column(
                  children: [
                    const Text('Reviewed'),
                    Text('12',style: GoogleFonts.robotoCondensed(
                      fontSize: 25,
                    ),),
                  ],
                ),
                Column(
                  children: [
                    const Text('Contacted'),
                    Text('5',style: GoogleFonts.robotoCondensed(
                      fontSize: 25,
                    ),),
                  ],
                ),
              ],
              ),
            ],
          ),
        ),
    
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30)
          ),
    
          child: Container(
          
            padding:const EdgeInsets.all(26),
            color: Colors.grey.shade400,
    
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:const [
                      Text('Contact for more Info',style: TextStyle(
                    fontSize: 22,
                  )),
                      Text('Personal | Experience | Qualification'),
                    ],
                  ),
                ),
    
                GestureDetector(
                onTap: () async{
                  //open linked in profile
                  final Uri uri = Uri.parse('https://www.facebook.com/aronjumawandevera?mibextid=ZbWKwL');
                  if (!await launchUrl(uri)){
                    print('error on launching');
                  }
                },
                
                child: const FaIcon(
                  FontAwesomeIcons.facebook)),
    
                const SizedBox(width: 12,),
                
                GestureDetector(
                onTap: () async{
                  //send message or call
                  final Uri uri = Uri.parse('tel:+639777313317');
                  if (!await launchUrl(uri)){
                    print('error on launching');
                  }
                },
    
                child: const FaIcon(
                  FontAwesomeIcons.phone)),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
)
);
}
}