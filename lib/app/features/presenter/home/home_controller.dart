import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nasa_clean_arch/app/core/usecase/errors/failure_nasa.dart';
import 'package:nasa_clean_arch/app/features/data/models/space_media_model.dart';
import 'package:nasa_clean_arch/app/features/domain/usecases/get_space_media_from_date_usecase.dart';
part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  late ScrollController scroll;
  final GetSpaceMediaFromDateUsecase usecase;
  init(){
    this.scroll = ScrollController();
    this.isVisibleDesc = false;
  }

  _HomeControllerBase(this.usecase);

  @observable
  bool isVisibleDesc = false;

  @action
  void slideDescription() {
    final positionNow = this.scroll.offset;
    late double height = this.scroll.position.maxScrollExtent;
    if (positionNow == height) {
      height = 0;
      isVisibleDesc = false;
    } else {
      isVisibleDesc = true;
    }
    this.scroll.animateTo(
          height,
          duration: Duration(milliseconds: 450),
          curve: Curves.easeInOutQuint,
        );
  }

  Option<DateTime> currentDate = none();

  Future<void> selectData(BuildContext context) async {
    final date = optionOf(
      await showDatePicker(
        context: context,
        initialDate: currentDate.fold(() => DateTime.now(), (d) => d),
        firstDate: DateTime(DateTime.now().year - 27),
        lastDate: DateTime.now(),
      ),
    );
    date.map((date) {
      currentDate = optionOf(date);
      Navigator.pushNamed(context, '/space-media');
    });
  }

  @observable
  bool loading = false;

  @observable
  Option<FailureNasa> failure = none();

  @observable
  Option<SpaceMediaModel> spacemedia = none();

  @action
  Future<void> getSpaceMedia() async {
    this.currentDate.map((date) async {
      this.loading = true;
      this.failure = none();
      final result = await usecase.call(date);
      result.fold(
        (failureResult) {
          loading = false;
          failure = optionOf(failureResult);
        },
        (entity) {
          // SpaceMediaModel
          loading = false;
          SpaceMediaModel model = SpaceMediaModel.fromEntity(entity: entity);
          this.spacemedia = some<SpaceMediaModel>(model);
        },
      );
    });
  }

  void disposerSpaceMedia() {
    this.failure = none();
    this.spacemedia = none();
    this.scroll.dispose();
  }
}
