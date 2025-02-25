import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:medapollo/Constant.dart";
import "package:medapollo/Services/API.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String type = "";
  String gender = "MALE";
  bool loading = false;
  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: type == ""
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              type = "user";
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                border: Border.all(
                                    color: Constant.Green, width: 2)),
                            child: Center(
                              child: Text(
                                "User",
                                style: TextStyle(
                                    color: Constant.Green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              type = "pharmacy";
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                border: Border.all(
                                    color: Constant.Green, width: 2)),
                            child: Center(
                              child: Text(
                                "Pharmacy",
                                style: TextStyle(
                                    color: Constant.Green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            )
          : type == "user"
              ? userAccount(context)
              : pharmacyAccount(),
    ));
  }

  pharmacyAccount() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 70),
              _input("email", emailController, false),
              const SizedBox(height: 20),
              _input("password", passwordController, true),
              const SizedBox(height: 20),
              _input("pharmacy name", nameController, false),
              const SizedBox(height: 20),
              _input("adress", addressController, false),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  pharmacyRegister();
                },
                child: Container(
                  width: 200,
                  height: 60,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Colors.green),
                  child: Center(
                    child: Text(
                      "create account",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  pharmacyRegister() async {
    await API.registerPharmacy(emailController.text, passwordController.text,
        nameController.text, addressController.text, context);
  }

  Container userAccount(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              page == 0 ? _firstPage() : _secondPage(),
              GestureDetector(
                onTap: () {
                  if (page == 0) {
                    setState(() {
                      page++;
                    });
                  } else {
                    _register();
                  }
                },
                child: Container(
                  width: 200,
                  height: 60,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Colors.green),
                  child: Center(
                    child: page == 0
                        ? FaIcon(
                            FontAwesomeIcons.arrowRight,
                            color: Colors.white,
                          )
                        : Text(
                            "create account",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _firstPage() {
    return Column(
      children: [
        const SizedBox(
          height: 90,
        ),
        _input("name", nameController, false),
        const SizedBox(
          height: 20,
        ),
        _input("last name", lastnameController, false),
        const SizedBox(
          height: 20,
        ),
        _input("phone", phoneController, false),
        const SizedBox(
          height: 20,
        ),
        _input("email", emailController, false),
        const SizedBox(
          height: 20,
        ),
        _input("password", passwordController, true),
        const SizedBox(
          height: 20,
        ),
        _input("Confirm password", passwordConfirmController, true),
        const SizedBox(
          height: 70,
        ),
      ],
    );
  }

  _secondPage() {
    return Column(
      children: [
        const SizedBox(
          height: 90,
        ),
        _input("address", addressController, false),
        const SizedBox(
          height: 20,
        ),
        _input("age", ageController, false),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      gender = "MALE";
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: gender == "MALE"
                          ? Colors.green[200]
                          : Colors.green[500],
                    ),
                    child: Center(child: Text("Male")),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      gender = "FEMALE";
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: gender == "FEMALE"
                          ? Colors.green[200]
                          : Colors.green[500],
                    ),
                    child: Center(child: Text("Female")),
                  ),
                )
              ]),
        ),
        const SizedBox(
          height: 90,
        ),
      ],
    );
  }

  _input(String hint, TextEditingController controller, bool pass) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      height: 50,
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        obscureText: pass,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

  _register() async {
    setState(() {
      loading = true;
    });
    await API.register(
        nameController.text,
        lastnameController.text,
        emailController.text,
        phoneController.text,
        passwordController.text,
        gender,
        addressController.text,
        ageController.text,
        context);
    setState(() {
      loading = false;
    });
  }
}
