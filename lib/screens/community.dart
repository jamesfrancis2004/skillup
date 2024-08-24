import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutgoingMessage extends StatelessWidget {
  final String username;
  final String message;
  final String datetime;
  const OutgoingMessage({
    Key? key,
    required this.username,
    required this.message,
    required this.datetime,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        username,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        )
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 80,
                    ),
                    Text(
                        datetime,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.0,
                        )
                    )
                  ]
              ),
              Text(
                  message,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                  )
              ),

            ]

        )


    );


  }
}


class IncomingMessage extends StatelessWidget {
  final String username;
  final String message;
  final String datetime;
  const IncomingMessage({
    Key? key,
    required this.username,
    required this.message,
    required this.datetime,
}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                username,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                )
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 80,
              ),
              Text(
                datetime,
                style: GoogleFonts.montserrat(
                  fontSize: 12.0,
                )
              )
            ]
          ),
          Text(
            message,
            style: GoogleFonts.montserrat(
              fontSize: 14.0,
            )
          ),

          ]

      )


    );


  }

}
// WIDGET 
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});  
  
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}


// STATE
class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Community",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  )
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                        child: Column(
                            children: [
                              IncomingMessage(
                                username: "Jimbo",
                                message: "This is an example message",
                                datetime: "12/11/2000 6:56pm",
                              ),
                              OutgoingMessage(
                                username: "ethtuah",
                                message: "This is an outgoing message",
                                datetime: "12/11/2000 6:57pm",
                              )

                            ]
                        )
                    )

                  )
                )
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 70,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Send a message",
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      minLines: 1,  // Minimum number of lines for the text field
                      maxLines: 5,  // Makes the TextField height dynamic
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {
                      // Handle file attachment
                      _showAttachmentOptions(context);
                    },
                  ),
                ],
              ),

            ]
          )
        )
      )
    );


  }
}

void _showAttachmentOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 150,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Photo'),
              onTap: () {
                // Handle photo selection
              },
            ),
            ListTile(
              leading: Icon(Icons.video_call),
              title: Text('Video'),
              onTap: () {
                // Handle video selection
              },
            ),
          ],
        ),
      );
    },
  );
}

