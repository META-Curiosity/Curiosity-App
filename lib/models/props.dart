import 'package:curiosity_flutter/models/user.dart';

//Contains data to be passed between screens to access the backend
class dataToBePushed {
  final User user;
  final String id;

  const dataToBePushed(this.user, this.id);
}
