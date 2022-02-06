import 'package:flutter_micro_app/src/utils/extensions/list_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('[list1.equals(list2)]', () {
    test(
        '\nDeve: retornar true'
        '\nQuando: verificar equality'
        '\nDesde que: as duas listas possuam os mesmos itens e na mesma order',
        () {
      // arrange
      final list1 = ['one', 'two', 'three'];
      final list2 = ['one', 'two', 'three'];

      // act
      final isEquals = list1.equals(list2);

      // assert
      expect(isEquals, equals(true));
    });

    test(
        '\nDeve: retornar true'
        '\nQuando: verificar equality'
        '\nDesde que: as duas listas possuam os mesmos itens e não estejam na mesma order',
        () {
      // arrange
      final list1 = ['one', 'two', 'three'];
      final list2 = ['three', 'two', 'one'];

      // act
      final isEquals = list1.equals(list2);

      // assert
      expect(isEquals, equals(true));
    });

    test(
        '\nDeve: retornar false'
        '\nQuando: verificar equality'
        '\nDesde que: a segunda lista não possua todos os itens da primeira lista',
        () {
      // arrange
      final list1 = ['one', 'two', 'three'];
      final list2 = ['three', 'two'];

      // act
      final isEquals = list1.equals(list2);

      // assert
      expect(isEquals, equals(false));
    });

    test(
        '\nDeve: retornar false'
        '\nQuando: verificar equality'
        '\nDesde que: a primeira lista não possua todos os itens da segunda lista',
        () {
      // arrange
      final list1 = ['three', 'two'];
      final list2 = ['one', 'two', 'three'];

      // act
      final isEquals = list1.equals(list2);

      // assert
      expect(isEquals, equals(false));
    });

    test(
        '\nDeve: retornar false'
        '\nQuando: verificar equality'
        '\nDesde que: a primeira lista não possua itens, mas a segunda lista, sim',
        () {
      // arrange
      final list1 = [];
      final list2 = ['one', 'two', 'three'];

      // act
      final isEquals = list1.equals(list2);

      // assert
      expect(isEquals, equals(false));
    });

    test(
        'Deve: retornar false'
        'Quando: verificar equality'
        'Desde que: a segunda lista não possua itens, mas a primeira lista, sim',
        () {
      // arrange
      final list1 = ['one', 'two', 'three'];
      final list2 = [];

      // act
      final isEquals = list1.equals(list2);

      // assert
      expect(isEquals, equals(false));
    });

    test(
        'Deve: retornar true'
        'Quando: verificar equality'
        'Desde que: as duas listas estejam vazias', () {
      // arrange
      final list1 = [];
      final list2 = [];

      // act
      final isEquals = list1.equals(list2);

      // assert
      expect(isEquals, equals(true));
    });
  });

  group('[list2.equals(list1)]', () {
    test(
        '\nDeve: retornar true'
        '\nQuando: verificar equality'
        '\nDesde que: as duas listas possuam os mesmos itens e na mesma order',
        () {
      // arrange
      final list1 = ['one', 'two', 'three'];
      final list2 = ['one', 'two', 'three'];

      // act
      final isEquals = list2.equals(list1);

      // assert
      expect(isEquals, equals(true));
    });

    test(
        '\nDeve: retornar true'
        '\nQuando: verificar equality'
        '\nDesde que: as duas listas possuam os mesmos itens e não estejam na mesma order',
        () {
      // arrange
      final list1 = ['one', 'two', 'three'];
      final list2 = ['three', 'two', 'one'];

      // act
      final isEquals = list2.equals(list1);

      // assert
      expect(isEquals, equals(true));
    });

    test(
        '\nDeve: retornar false'
        '\nQuando: verificar equality'
        '\nDesde que: a segunda lista não possua todos os itens da primeira lista',
        () {
      // arrange
      final list1 = ['one', 'two', 'three'];
      final list2 = ['three', 'two'];

      // act
      final isEquals = list2.equals(list1);

      // assert
      expect(isEquals, equals(false));
    });

    test(
        '\nDeve: retornar false'
        '\nQuando: verificar equality'
        '\nDesde que: a primeira lista não possua todos os itens da segunda lista',
        () {
      // arrange
      final list1 = ['three', 'two'];
      final list2 = ['one', 'two', 'three'];

      // act
      final isEquals = list2.equals(list1);

      // assert
      expect(isEquals, equals(false));
    });

    test(
        '\nDeve: retornar false'
        '\nQuando: verificar equality'
        '\nDesde que: a primeira lista não possua itens, mas a segunda lista, sim',
        () {
      // arrange
      final list1 = [];
      final list2 = ['one', 'two', 'three'];

      // act
      final isEquals = list2.equals(list1);

      // assert
      expect(isEquals, equals(false));
    });

    test(
        'Deve: retornar false'
        'Quando: verificar equality'
        'Desde que: a segunda lista não possua itens, mas a primeira lista, sim',
        () {
      // arrange
      final list1 = ['one', 'two', 'three'];
      final list2 = [];

      // act
      final isEquals = list2.equals(list1);

      // assert
      expect(isEquals, equals(false));
    });

    test(
        'Deve: retornar true'
        'Quando: verificar equality'
        'Desde que: as duas listas estejam vazias', () {
      // arrange
      final list1 = [];
      final list2 = [];

      // act
      final isEquals = list2.equals(list1);

      // assert
      expect(isEquals, equals(true));
    });
  });
}
