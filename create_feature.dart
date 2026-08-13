import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide a feature name.');
    print('Usage: dart create_feature.dart <feature_name>');
    exit(1);
  }

  final featureName = args.first;
  // Use Platform.pathSeparator to ensure it works properly across different OS if ever moved,
  // though Dart handles forward slashes well on Windows too.
  final baseDir = 'lib/features/$featureName';

  final directories = [
    '$baseDir/api/api_client',
    '$baseDir/api/datasources',
    '$baseDir/data/datasources',
    '$baseDir/data/models',
    '$baseDir/data/models/requests',
    '$baseDir/data/models/response',
    '$baseDir/data/repositories',
    '$baseDir/domain/entities',
    '$baseDir/domain/repositories',
    '$baseDir/domain/use_cases',
    '$baseDir/presentation/cubit',
    '$baseDir/presentation/pages',
    '$baseDir/presentation/widgets',
  ];

  final pascalCaseName = featureName
      .split('_')
      .map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1);
      })
      .join('');

  final files = {
    '$baseDir/api/api_client/${featureName}_api_client.dart':
        '''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part '${featureName}_api_client.g.dart';

@RestApi()
abstract interface class ${pascalCaseName}ApiClient {
  @factoryMethod
  factory ${pascalCaseName}ApiClient(Dio dio, {String baseUrl}) = _${pascalCaseName}ApiClient;
}
''',
    '$baseDir/api/datasources/${featureName}_remote_data_source_impl.dart':
        '''
import 'package:injectable/injectable.dart';
import '../../data/datasources/${featureName}_remote_data_source.dart';

@LazySingleton(as: ${pascalCaseName}RemoteDataSource)
class ${pascalCaseName}RemoteDataSourceImpl implements ${pascalCaseName}RemoteDataSource {
  // TODO: Implement
}
''',
    '$baseDir/data/datasources/${featureName}_remote_data_source.dart':
        '''
abstract class ${pascalCaseName}RemoteDataSource {
  // TODO: Implement
}
''',
    '$baseDir/data/repositories/${featureName}_repo_impl.dart':
        '''
import 'package:injectable/injectable.dart';
import '../../domain/repositories/${featureName}_repo.dart';

@Injectable(as: ${pascalCaseName}Repo)
class ${pascalCaseName}RepoImpl implements ${pascalCaseName}Repo {
  // TODO: Implement
}
''',
    '$baseDir/domain/repositories/${featureName}_repo.dart':
        '''
abstract class ${pascalCaseName}Repo {
  // TODO: Implement
}
''',
    '$baseDir/presentation/cubit/${featureName}_event.dart':
        '''
abstract class ${pascalCaseName}Event {}
''',
    '$baseDir/presentation/cubit/${featureName}_state.dart':
        '''
abstract class ${pascalCaseName}State {}
class ${pascalCaseName}Initial extends ${pascalCaseName}State {}
''',
    '$baseDir/presentation/cubit/${featureName}_cubit.dart':
        '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '${featureName}_event.dart';
import '${featureName}_state.dart';

@injectable
class ${pascalCaseName}Cubit extends Cubit<${pascalCaseName}State> {
  ${pascalCaseName}Cubit() : super(${pascalCaseName}Initial());
}
''',
    '$baseDir/presentation/pages/${featureName}_page.dart':
        '''
import 'package:flutter/material.dart';

class ${pascalCaseName}Page extends StatelessWidget {
  const ${pascalCaseName}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${pascalCaseName}Page'),
      ),
    );
  }
}
''',
  };

  print('Creating feature: $featureName');

  for (final dir in directories) {
    Directory(dir).createSync(recursive: true);
    print('  - Created: $dir');
  }

  for (final entry in files.entries) {
    File(entry.key).writeAsStringSync(entry.value);
    print('  - Created file: ${entry.key}');
  }

  for (final dir in directories) {
    final dirList = Directory(dir).listSync();
    if (dirList.isEmpty) {
      File('$dir/.gitkeep').writeAsStringSync('');
      print('  - Added .gitkeep to empty folder: $dir');
    }
  }

  print(
    '\\nFeature architecture and files for "$featureName" created successfully!',
  );
}
