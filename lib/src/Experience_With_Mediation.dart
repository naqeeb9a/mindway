import 'package:flutter/material.dart';
import 'package:mindway/utils/textfield.dart';
class ExperienceWithMediation extends StatefulWidget {
  static const String routeName1 = "/experience_with_mediation";
  const ExperienceWithMediation({Key? key}) : super(key: key);

  @override
  State<ExperienceWithMediation> createState() => _ExperienceWithMediationState();
}

class _ExperienceWithMediationState extends State<ExperienceWithMediation> {

  @override
  Widget build(BuildContext context) {
    double baseWidth = 377;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // frame19Li (4:855)
        width: double.infinity,
        height: 861*fem,
        decoration: BoxDecoration (
          color: Color(0xffffffff),
        ),
        child: Stack(
          children: [

            Positioned(
              // whatsyourexperiencewithmediati (4:829)
              left: 75.5*fem,
              top: 174*fem,
              child: Align(
                child: SizedBox(
                  width: 223*fem,
                  height: 123*fem,
                  child: Text(
                    'What’s Your \nExperience With Mediation? ',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont (
                      'Anteb',
                      fontSize: 33*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2424242424*ffem/fem,
                      letterSpacing: 0.1221000016*fem,
                      color: Color(0xff454545),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // buttontTx (4:833)
              left: 15*fem,
              top: 632*fem,
              child: Container(
                width: 343*fem,
                height: 56*fem,
                decoration: BoxDecoration (
                  color: Color(0xff688edc),
                  borderRadius: BorderRadius.circular(90*fem),
                ),
                child: Center(
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont (
                      'Anteb',
                      fontSize: 17*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2941176471*ffem/fem,
                      letterSpacing: 0.068000001*fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // button7bc (4:836)
              left: 16*fem,
              top: 545*fem,
              child: Container(
                padding: EdgeInsets.fromLTRB(17*fem, 17*fem, 17*fem, 17*fem),
                width: 343*fem,
                height: 56*fem,
                decoration: BoxDecoration (
                  color: Color(0xffdae1f2),
                  borderRadius: BorderRadius.circular(8*fem),
                ),
                child: Container(
                  // contentbFt (I4:836;120:24)
                  padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 2.74*fem, 0*fem),
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // learnmoreWNr (I4:836;120:25)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 139.74*fem, 0*fem),
                        child: Text(
                          'Meditate Everyday',
                          style: SafeGoogleFont (
                            'DM Sans',
                            fontSize: 17*ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.2941176471*ffem/fem,
                            letterSpacing: 0.068000001*fem,
                            color: Color(0xff3c3c3c),
                          ),
                        ),
                      ),
                      Container(
                        // checkmarkCWa (I4:836;120:26)
                        margin: EdgeInsets.fromLTRB(0*fem, 0.26*fem, 0*fem, 0*fem),
                        width: 14.52*fem,
                        height: 10.11*fem,
                        child: Image.asset(
                          'assets/page-1/images/checkmark-T34.png',
                          width: 14.52*fem,
                          height: 10.11*fem,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              // buttonWnA (4:837)
              left: 16*fem,
              top: 473*fem,
              child: Container(
                padding: EdgeInsets.fromLTRB(17*fem, 17*fem, 17*fem, 17*fem),
                width: 343*fem,
                height: 56*fem,
                decoration: BoxDecoration (
                  color: Color(0xffdae1f2),
                  borderRadius: BorderRadius.circular(8*fem),
                ),
                child: Container(
                  // contentzxE (I4:837;120:24)
                  width: double.infinity,
                  height: double.infinity,
                  child: Text(
                    'Meditate Occasionally',
                    style: SafeGoogleFont (
                      'DM Sans',
                      fontSize: 17*ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.2941176471*ffem/fem,
                      letterSpacing: 0.068000001*fem,
                      color: Color(0xff3c3c3c),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // button6Ea (4:838)
              left: 16*fem,
              top: 401*fem,
              child: Container(
                padding: EdgeInsets.fromLTRB(17*fem, 17*fem, 17*fem, 17*fem),
                width: 343*fem,
                height: 56*fem,
                decoration: BoxDecoration (
                  color: Color(0xffdae1f2),
                  borderRadius: BorderRadius.circular(8*fem),
                ),
                child: Container(
                  // contentavS (I4:838;120:24)
                  width: double.infinity,
                  height: double.infinity,
                  child: Text(
                    'Tried it once or twice',
                    style: SafeGoogleFont (
                      'DM Sans',
                      fontSize: 17*ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.2941176471*ffem/fem,
                      letterSpacing: 0.068000001*fem,
                      color: Color(0xff3c3c3c),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // buttontgE (4:839)
              left: 16*fem,
              top: 329*fem,
              child: Container(
                padding: EdgeInsets.fromLTRB(17*fem, 17*fem, 17*fem, 17*fem),
                width: 343*fem,
                height: 56*fem,
                decoration: BoxDecoration (
                  color: Color(0xff688edc),
                  borderRadius: BorderRadius.circular(8*fem),
                ),
                child: Container(
                  // contentnWi (I4:839;120:24)
                  padding: EdgeInsets.fromLTRB(0*fem, 0*fem, 2.74*fem, 0*fem),
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // learnmorev78 (I4:839;120:25)
                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 135.74*fem, 0*fem),
                        child: Text(
                          'None, I’m a newbie!',
                          style: SafeGoogleFont (
                            'DM Sans',
                            fontSize: 17*ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.2941176471*ffem/fem,
                            letterSpacing: 0.068000001*fem,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      Container(
                        // checkmark2fx (I4:839;120:26)
                        margin: EdgeInsets.fromLTRB(0*fem, 0.26*fem, 0*fem, 0*fem),
                        width: 14.52*fem,
                        height: 10.11*fem,
                        child: Image.asset(
                          'assets/page-1/images/checkmark.png',
                          width: 14.52*fem,
                          height: 10.11*fem,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
