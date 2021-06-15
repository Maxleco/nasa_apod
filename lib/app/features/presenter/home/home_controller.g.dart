// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  final _$isVisibleDescAtom = Atom(name: '_HomeControllerBase.isVisibleDesc');

  @override
  bool get isVisibleDesc {
    _$isVisibleDescAtom.reportRead();
    return super.isVisibleDesc;
  }

  @override
  set isVisibleDesc(bool value) {
    _$isVisibleDescAtom.reportWrite(value, super.isVisibleDesc, () {
      super.isVisibleDesc = value;
    });
  }

  final _$loadingAtom = Atom(name: '_HomeControllerBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$failureAtom = Atom(name: '_HomeControllerBase.failure');

  @override
  Option<FailureNasa> get failure {
    _$failureAtom.reportRead();
    return super.failure;
  }

  @override
  set failure(Option<FailureNasa> value) {
    _$failureAtom.reportWrite(value, super.failure, () {
      super.failure = value;
    });
  }

  final _$spacemediaAtom = Atom(name: '_HomeControllerBase.spacemedia');

  @override
  Option<SpaceMediaModel> get spacemedia {
    _$spacemediaAtom.reportRead();
    return super.spacemedia;
  }

  @override
  set spacemedia(Option<SpaceMediaModel> value) {
    _$spacemediaAtom.reportWrite(value, super.spacemedia, () {
      super.spacemedia = value;
    });
  }

  final _$getSpaceMediaAsyncAction =
      AsyncAction('_HomeControllerBase.getSpaceMedia');

  @override
  Future<void> getSpaceMedia() {
    return _$getSpaceMediaAsyncAction.run(() => super.getSpaceMedia());
  }

  final _$_HomeControllerBaseActionController =
      ActionController(name: '_HomeControllerBase');

  @override
  void slideDescription() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.slideDescription');
    try {
      return super.slideDescription();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isVisibleDesc: ${isVisibleDesc},
loading: ${loading},
failure: ${failure},
spacemedia: ${spacemedia}
    ''';
  }
}
