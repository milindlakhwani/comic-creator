import 'package:fpdart/fpdart.dart';
import 'package:comic_creator/core/failure.dart';

// T over here means that we can give any type, e.g. it can be FutureEither<UserModel> or any data type.
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
