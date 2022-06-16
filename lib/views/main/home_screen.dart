import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailto/mailto.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../models/invite_users.dart';
import '../../models/userDetails.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSelected = true;

  List<UserDetails> users = [];
  List usersEmail = [];

  String? email;
  String? password;
  bool loading = false;
  bool remember = false;
  bool _btnEnabled = false;

  final List<String> errors = [];

  String activeApprovalFilter = 'Users';
  List buttons = ['Users', 'Invite'];

  List<String> attachments = [];
  bool isHTML = false;

  final _subjectController =
      TextEditingController(text: 'Peas Cloud Application Invite Link');

  final _bodyController = TextEditingController(
    text: 'Invite link will be - ',
  );

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void addError({String? error}) {
    if (!errors.contains(error))
      // setState(() {
      errors.add(error!);
    // });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      //  setState(() {
      errors.remove(error!);
    // });
  }

  fetchData() async {
    users = await userController.getAllUsers();
    usersEmail = await userController.getUsersInviteEmails();

    setState(() {});

    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, int buttonsIndex) =>
                      dashboardButtons(buttons[buttonsIndex], () async {
                        if (buttons[buttonsIndex] == 'Users') {
                          setState(() {
                            isSelected = true;
                            activeApprovalFilter = buttons[buttonsIndex];
                          });
                        } else {
                          setState(() {
                            isSelected = false;
                            activeApprovalFilter = buttons[buttonsIndex];
                          });
                        }
                      })),
            ),
            SizedBox(
              height: 20,
            ),
            isSelected
                ? users.length == 0 || users.length == 1
                    ? Center(
                        child: Text('No users found'),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return users[index].role == 'admin'
                              ? SizedBox()
                              : ListTile(
                                  title: Text(users[index].name),
                                  subtitle: Text(users[index].email),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.delete),
                                  ),
                                );
                        })
                : Container(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            buildEmailFormField(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                  onTap: sendMail,
                                  child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: _btnEnabled
                                              ? kColorPrimary
                                              : kLightGrey),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.send,
                                          color: kWhite,
                                        ),
                                      ))),
                            )
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding:
                      //   const EdgeInsets.symmetric(
                      //       horizontal: 18.0,
                      //       vertical: 8),
                      //   child: TextField(
                      //     readOnly: true,
                      //     onTap: () {
                      //       showSearch(
                      //           context: context,
                      //           delegate: DataSearch(users));
                      //     },
                      //     keyboardType:
                      //     TextInputType.text,
                      //     decoration: InputDecoration(
                      //         contentPadding:
                      //         const EdgeInsets.only(
                      //             left: 14.0,
                      //             bottom: 12.0,
                      //             top: 0.0),
                      //         filled: true,
                      //         fillColor:
                      //         Colors.grey.shade200,
                      //         hintText: 'Search Users',
                      //         hintStyle:
                      //         GoogleFonts.inter(
                      //           fontWeight:
                      //           FontWeight.w300,
                      //         ),
                      //         border: OutlineInputBorder(
                      //           borderRadius:
                      //           BorderRadius.circular(
                      //               7.0),
                      //           borderSide: BorderSide(
                      //             width: 0,
                      //             style: BorderStyle.none,
                      //           ),
                      //         ),
                      //         prefixIcon: Icon(
                      //           Icons.search,
                      //           color: Colors.black,
                      //           size: 30,
                      //         )),
                      //   ),
                      // ),

                      SizedBox(
                        height: 20,
                      ),

                      usersEmail.length == 0
                          ? Center(
                              child: Text('No user invited.'),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Already invite sent',
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: kDarkBlack,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),

                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        height: 200,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: usersEmail.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(usersEmail[index].email),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Re-send',
                                          style: GoogleFonts.inter(
                                              color: kDarkBlack,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.delete,
                                              color: kLightGrey,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: kLightGrey,
                                  )
                                ],
                              );
                            }),
                      ),
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  Widget buildEmailFormField() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          controller: emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          onSaved: (newValue) => email = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kEmailNullError);
            } else if (emailValidatorRegExp.hasMatch(value)) {
              removeError(error: kInvalidEmailError);
            } else {
              setState(() {
                _btnEnabled = true;
              });
            }

            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kEmailNullError);
              return kEmailNullError;
            } else if (!emailValidatorRegExp.hasMatch(value)) {
              addError(error: kInvalidEmailError);
              return kInvalidEmailError;
            }
            return null;
          },
          decoration: new InputDecoration(
            //  helperText: '',
            // fillColor: Colors.grey[100],
            //filled: true,
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorStyle: TextStyle(color: Colors.pink),
            //  contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey, width: 1)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
            ),
            hintText: 'yourmail@domain.com',
          ),
        ),
      ),
    );
  }

  //buttons
  Widget dashboardButtons(String text, onPress) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Padding(
          padding: EdgeInsets.only(right: 0, left: 0),
          child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  side: BorderSide(color: Colors.grey)),
              padding: EdgeInsets.all(0),
              height: 15,
              onPressed: onPress,
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontWeight: activeApprovalFilter == text
                      ? FontWeight.w700
                      : FontWeight.w300,
                  color: activeApprovalFilter == text
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                ),
              ),
              color:
                  activeApprovalFilter == text ? kColorPrimary : Colors.white)),
    );
  }

  sendMail() {
    if (kIsWeb) {
      launchMailto();
    } else {
      send();
    }
  }

  Future<void> send() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      final Email email = Email(
        body: _bodyController.text,
        subject: _subjectController.text,
        recipients: [emailController.text],
        attachmentPaths: attachments,
        isHTML: isHTML,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        String result = await userController.addUserEmail({
          'email': emailController.text,
          'timeStamp': DateTime.now().toString()
        });

        emailController.clear();
        platformResponse = 'Invite link sent.';
      } catch (error) {
        print(error);
        platformResponse = error.toString();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(platformResponse),
        ),
      );
    }
  }

  launchMailto() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      final mailtoLink = Mailto(
        to: [emailController.text],
        subject: _subjectController.text,
        body: _bodyController.text,
      );

      String platformResponse;

      try {
        await launchUrl(Uri.parse(mailtoLink.toString()));

        String result = await userController.addUserEmail({
          'email': emailController.text,
          'timeStamp': DateTime.now().toString()
        });

        emailController.clear();
        platformResponse = 'Invite link sent.';
      } catch (error) {
        print(error);
        platformResponse = error.toString();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(platformResponse),
        ),
      );
    }

    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
  }
}
