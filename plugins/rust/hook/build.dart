import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

const packageName = 'rust';

void main(List<String> args) async {
  await build(args, (config, output) async {
    final builder = RustBuilder(
      package: packageName,
      cratePath: 'src/palette_extractor',
      // Specify custom name to match the dart file, otherwise crate name is used.
      assetName: '${packageName}_bindings_generated.dart',
      buildConfig: config,
      useNativeManifest: false,
    );
    await builder.run(output: output);
    output.addDependencies([
      config.packageRoot.resolve('hook/build.dart'),
    ]);
  });
}
