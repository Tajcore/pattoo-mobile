import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pattoomobile/api/api.dart';
import 'package:pattoomobile/controllers/agent_controller.dart';
import 'package:pattoomobile/controllers/theme_manager.dart';
import 'package:pattoomobile/controllers/userState.dart';
import 'package:provider/provider.dart';
import 'package:pattoomobile/util/AspectRation.dart';
import 'DarkModeSwitch.dart';
import 'ShowFavSwitch.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SettingsContainer extends StatefulWidget {
  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {


  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  final email = TextEditingController();
  final password = TextEditingController();

  String dropdownValue = 'HTTP';
  String dropdownValue2 = '/pattoo/api/v1/web/graphql';
  bool inAsyncCall = false;
  bool isInvalidURL = false;
  Widget icon = Icon(
    Icons.assessment,
    color: Colors.grey,
    size: 25.0,
  );
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ModalProgressHUD(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return _buildVerticalLayout(context);
          },
        ),
        inAsyncCall: inAsyncCall,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildVerticalLayout(context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return new Scaffold(
      body: Container(
        height: SizeConfig.blockSizeVertical * 51,
        width: SizeConfig.blockSizeHorizontal * 220,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: SizedBox(
              width: queryData.size.width * 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DarkModeWidget(),
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        new Flexible(
                          child: icon,
                        ),
                        SizedBox(
                          width: 38,
                        ),
                        SizedBox(
                          width: queryData.size.width * 0.45,
                          child: TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              hintText: "Pattoo API URL",
                              helperText: "eg. Calico.palisadoes.org",
                            ),
                            validator: validate,
                          ),
                        ),

                        // flex:1,
                        SizedBox(
                          width: queryData.size.width * 0.05,
                        ),
                        new DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                            color: Provider.of<ThemeManager>(context)
                                .themeData
                                .primaryTextTheme
                                .headline6
                                .color,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>[
                            'HTTP',
                            'HTTPS',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RaisedButton(
                          onPressed: _submit,
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Text('Submit'),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validate(String text) {
    print(isInvalidURL);
    if (isInvalidURL) {
      return null;
    } else {
      return "Invalid API URL";
    }
  }

  Future Validate_pattoo(String text) async {
    setState(() {
      this.inAsyncCall = true;
    });
    String uri =
        "${dropdownValue.toLowerCase()}://${text.trim()}/pattoo/api/v1/web/graphql";
    QueryOptions options = QueryOptions(
      documentNode: gql(AgentFetch().getAllAgents),
      variables: <String, String>{
        // set cursor to null so as to start at the beginning
        // 'cursor': 10
      },
    );
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(uri: uri),
    );
    QueryResult result = await _client.query(options);
    print("we here");
    if (result.loading && result.data == null) {
      print("loading");
    }
    if (result.hasException) {
      print("error");
      setState(() {
        this.isInvalidURL = false;
        icon = Icon(
          Icons.error,
          color: Colors.red,
          size: 25.0,
        );
        this.inAsyncCall = false;
      });
    }
    if (!result.hasException) {
      setState(() {
        icon = Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 25.0,
        );
        this.isInvalidURL = true;
        this.inAsyncCall = false;
      });
    }
    //Pop login information
    if(!result.hasException)
      {
        getUserInfo(context);
      }
    setState(() {
      this.inAsyncCall = false;
    });
  }

  //function to validate url input
  void _submit() async {
    var _source = textController.text;
    await Validate_pattoo(_source);
    print(formKey.currentState.validate());
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(_source);
      String uri = "${dropdownValue.toLowerCase()}://${_source.trim()}/pattoo/api/v1/web";
      Provider.of<AgentsManager>(context, listen: false).setLink(uri);
      Provider.of<AgentsManager>(context, listen: false).loaded = true;
      print(Provider.of<AgentsManager>(context, listen: false).loaded);
      print(Provider.of<AgentsManager>(context, listen: false).link);
      Provider.of<AgentsManager>(context, listen: false)
          .loadAgents(context)
          .then((val) {
        Provider.of<UserState>(context, listen: false)
            .loadFavourites(context)
            .then((res) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pushNamed(context, '/HomeScreen');
          });
        });
      });
    }
  }


  //Authentication
  Future ValidateUser(String text) async{
    var userEmail = email.text;
    var userPassword = password.text;
    print(userEmail);
    print(userPassword);
    setState(() {
      this.inAsyncCall = true;
    });
    String uri =
        "${dropdownValue.toLowerCase()}://${text.trim()}/pattoo/api/v1/web/graphql";
    QueryOptions options = QueryOptions(
      documentNode: gql(AgentFetch().Authentication),
      variables: <String, String>{
        'username': userEmail,
        'password': userPassword,
      },
    );
    GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: new HttpLink(uri: uri),
    );
    QueryResult result = await _client.query(options);
    if (result.loading && result.data == null) {
      print("loading");
    }
    if(!result.hasException)
      {
        print(userEmail);
        print(userPassword);
        print(result.data["id"]);
          if(result.data["id"]== null)
            {
              print(uri);
              Navigator.of(context).pop();
              _notInSystem();
            }
          else
            {
              print(uri);
              Navigator.pushNamed(context, '/HomeScreen');
            }
          //give welcome message?
          //Then navigate close and navigate to home

      }
    else
      {
        print(result.exception.toString());
        print(uri);
        //Message user not in system

      }
  }

  Future<void> _notInSystem() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

          title: Text('This user is not in the system'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Try re-entering user login details or contact server admin'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                email.clear();
                password.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


    //Getting user info from pop/up login screen
  getUserInfo(BuildContext context)
  {
    var _source = textController.text;
    MediaQueryData queryData = MediaQuery.of(context);

    return showDialog(context: context, builder: (context)
    {
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
        title: Text("LOGIN"),
        content: Container(
          child: Column(
            children: <Widget>[
              TextField(
                controller: email,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Username',
                ),
              ),

              TextField(
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                child: RaisedButton(
                  elevation: 5.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(queryData.size.shortestSide * 0.015)),
                  onPressed: () {
                    ValidateUser(_source);
                  },
                  child: const Text('Login',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        ));
    });
  }
}
