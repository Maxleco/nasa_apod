import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:nasa_clean_arch/app/features/presenter/home/home_controller.dart';

class SpaceMediaPage extends StatefulWidget {
  const SpaceMediaPage({Key? key}) : super(key: key);
  @override
  _SpaceMediaPageState createState() => _SpaceMediaPageState();
}

class _SpaceMediaPageState extends State<SpaceMediaPage> {
  final controller = Modular.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.init();
    // controller.getSpaceMedia();
  }

  @override
  void dispose() {
    super.dispose();
    controller.disposerSpaceMedia();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('APOD'),
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) {
          //* Alternativa in Server ERRO
          return altCardSlide(context, size);

          if (controller.loading) {
            return Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
                ),
              ),
            );
          }

          if (controller.failure.isSome()) {
            return controller.failure.fold(
              () => Container(),
              (failureResult) {
                if (failureResult is NasaServerFailure) {
                  return Expanded(
                    child: Center(
                      child: Text('Falha ao recuperar os Dados!'),
                    ),
                  );
                }
                if (failureResult is NasaServerException) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'ERRO NA CONEXÃO AO SERVER!',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  );
                }
                return Container();
              },
            );
          }

          return controller.spacemedia.fold(() => Container(), (spacemedia) {
            if (spacemedia.mediaType == 'image') {
              return Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height,
                      alignment: AlignmentDirectional.center,
                      child: CachedNetworkImage(
                        width: size.width,
                        height: size.height,
                        fit: BoxFit.cover,
                        imageUrl: spacemedia.mediaUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          return Container(
                            width: 30,
                            height: 30,
                            alignment: AlignmentDirectional.center,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        width: size.width,
                        height: size.height * 0.10,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.grey[400],
                            ),
                            Text(
                              'Slide up to see the description.',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   child: Container(
                    //     padding: EdgeInsets.all(10),
                    //     width: size.width,
                    //     height: size.height * 0.25,
                    //     decoration: BoxDecoration(
                    //       color: Colors.black38,
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           spacemedia.title,
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //         SizedBox(height: 10),
                    //         Expanded(
                    //           child: Text(
                    //             spacemedia.description,
                    //             style: TextStyle(
                    //               fontSize: 13,
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.w400,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          });
        },
      ),
    );
  }

  final desc =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
  Widget altCardSlide(BuildContext context, Size size) {
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          alignment: AlignmentDirectional.center,
          child: CachedNetworkImage(
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
            imageUrl:
                'https://d1otjdv2bf0507.cloudfront.net/images/Article_Images/ImageForArticle_4983(1).jpg',
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Container(
                width: 30,
                height: 30,
                alignment: AlignmentDirectional.center,
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              );
            },
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        Container(
          width: size.width,
          height: size.height,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.scroll,
            children: [
              Container(
                height: size.height * 0.85,
                color: Color.fromRGBO(0, 0, 0, 0),
              ),
              Container(
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.black54,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => controller.slideDescription(),
                      child: Container(
                        width: 180,
                        alignment: Alignment.center,
                        child: AnimatedCrossFade(
                          duration: Duration(milliseconds: 450),
                          firstChild: Column(
                            children: [
                              Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.grey[400],
                              ),
                              Text(
                                'Slide up to see the description.',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey[400],
                              ),
                              Container(height: 10),
                            ],
                          ),
                          crossFadeState: controller.isVisibleDesc
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: size.width,
                      height: size.height * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title Space Media',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              this.desc,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
