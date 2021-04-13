import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:test/test.dart';

void main() {
  group('Party Bloc', () {
    late var partyBloc;

    setUp(() {
      partyBloc = PartyBloc();
    });

    test('initial state should be PartyInitial', () async {
      await expectLater(partyBloc.state is PartyInitial, true);
    });
  });
}
