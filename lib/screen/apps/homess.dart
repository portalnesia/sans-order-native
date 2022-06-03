import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: MediaQuery.of(context).padding,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: const [
            Section1(),
            Section2()
          ],
        )
      ),
    );
  }
}

class Section1 extends StatelessWidget {
  const Section1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10.0),
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Kembangkan Bisnis Anda dengan ',
            style: Theme.of(context).textTheme.headline3,
            children: const [
              TextSpan(text: 'SansOrder',style: TextStyle(color: Color.fromARGB(255, 47, 111, 78),fontWeight: FontWeight.bold))
            ]
          )
        ),
      )
    );
  }
}

class Section2 extends StatelessWidget {
  const Section2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10.0),
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Kembangkan Bisnis Anda dengan ',
            style: Theme.of(context).textTheme.headline3,
            children: const [
              TextSpan(text: 'SansOrder',style: TextStyle(color: Color.fromARGB(255, 47, 111, 78),fontWeight: FontWeight.bold))
            ]
          )
        ),
      )
    );
  }
}