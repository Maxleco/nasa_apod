import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:nasa_clean_arch/app/features/data/models/space_media_model.dart';
import 'package:nasa_clean_arch/app/features/presenter/home/home_controller.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    controller.getSpaceMedia();
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
          if (controller.loading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
              ),
            );
          }

          if (controller.failure.isSome()) {
            return controller.failure.fold(
              () => Container(),
              (failureResult) {
                if (failureResult is NasaServerFailure) {
                  return Center(
                    child: Text('Falha ao recuperar os Dados!'),
                  );
                }
                if (failureResult is NasaServerException) {
                  return Center(
                    child: Text(
                      'ERRO NA CONEXÃO AO SERVER!',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                return Container();
              },
            );
          }

          return controller.spacemedia.fold(() => Container(), (spacemedia) {
            if (spacemedia.mediaType == 'image') {
              return getSpaceMediaImage(spacemedia, size);
            } else {
              return getSpaceMediaVideo(spacemedia, size);
            }
          });
        },
      ),
    );
  }

  Widget getSpaceMediaImage(SpaceMediaModel spacemedia, Size size) {
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
            imageUrl: spacemedia.mediaUrl,
            placeholder: (context, url) {
              return Container(
                width: 30,
                height: 30,
                alignment: AlignmentDirectional.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
                ),
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
                height: size.height * 0.42,
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
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      width: size.width,
                      height: size.height * 0.3425,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spacemedia.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              spacemedia.description,
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

  Widget getSpaceMediaVideo(SpaceMediaModel spacemedia, Size size) {
    String videoId = '';
    late Widget video;
    bool isYoutube = spacemedia.mediaUrl.contains('youtube');
    bool isVimeo = spacemedia.mediaUrl.contains('vimeo');

    if (isVimeo) {
      String idvimeo = spacemedia.mediaUrl
          .replaceFirst('https://player.vimeo.com/video/', '');
      videoId = idvimeo.split('?').first;
      print(videoId.trim());
      video = VimeoPlayer(videoId: videoId.trim());
    }
    if (isYoutube) {
      videoId = YoutubePlayer.convertUrlToId(spacemedia.mediaUrl)!;
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ),
      );
      video = YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressColors: ProgressBarColors(
          playedColor: Colors.indigo,
          handleColor: Colors.indigoAccent,
        ),
        onReady: () {
          _controller.play();
        },
      );
    }

    return ListView(
      children: [
        Container(
          height: 250,
          child: video,
        ),
        SizedBox(height: 15),
        Container(
            padding: EdgeInsets.all(10),
            width: size.width,
            height: size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
        spacemedia.title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.indigo[900],
          fontWeight: FontWeight.w700,
        ),
                ),
                SizedBox(height: 10),
                Expanded(
        child: Text(
          spacemedia.description,
          style: TextStyle(
            fontSize: 13,
            color: Colors.indigo[900],
            fontWeight: FontWeight.w400,
          ),
        ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
