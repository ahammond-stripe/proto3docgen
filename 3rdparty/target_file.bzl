# Do not edit. bazel-deps autogenerates this file from.
_JAVA_LIBRARY_TEMPLATE = """
java_library(
  name = "{name}",
  exports = [
      {exports}
  ],
  runtime_deps = [
    {runtime_deps}
  ],
  visibility = [
      "{visibility}"
  ]
)\n"""

_SCALA_IMPORT_TEMPLATE = """
scala_import(
    name = "{name}",
    exports = [
        {exports}
    ],
    jars = [
        {jars}
    ],
    runtime_deps = [
        {runtime_deps}
    ],
    visibility = [
        "{visibility}"
    ]
)
"""

_SCALA_LIBRARY_TEMPLATE = """
scala_library(
    name = "{name}",
    exports = [
        {exports}
    ],
    runtime_deps = [
        {runtime_deps}
    ],
    visibility = [
        "{visibility}"
    ]
)
"""


def _build_external_workspace_from_opts_impl(ctx):
    build_header = ctx.attr.build_header
    separator = ctx.attr.separator
    target_configs = ctx.attr.target_configs

    result_dict = {}
    for key, cfg in target_configs.items():
      build_file_to_target_name = key.split(":")
      build_file = build_file_to_target_name[0]
      target_name = build_file_to_target_name[1]
      if build_file not in result_dict:
        result_dict[build_file] = []
      result_dict[build_file].append(cfg)

    for key, file_entries in result_dict.items():
      build_file_contents = build_header + '\n\n'
      for build_target in file_entries:
        entry_map = {}
        for entry in build_target:
          elements = entry.split(separator)
          build_entry_key = elements[0]
          if elements[1] == "L":
            entry_map[build_entry_key] = [e for e in elements[2::] if len(e) > 0]
          elif elements[1] == "B":
            entry_map[build_entry_key] = (elements[2] == "true" or elements[2] == "True")
          else:
            entry_map[build_entry_key] = elements[2]

        exports_str = ""
        for e in entry_map.get("exports", []):
          exports_str += "\"" + e + "\",\n"

        jars_str = ""
        for e in entry_map.get("jars", []):
          jars_str += "\"" + e + "\",\n"

        runtime_deps_str = ""
        for e in entry_map.get("runtimeDeps", []):
          runtime_deps_str += "\"" + e + "\",\n"

        name = entry_map["name"].split(":")[1]
        if entry_map["lang"] == "java":
            build_file_contents += _JAVA_LIBRARY_TEMPLATE.format(name = name, exports=exports_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        elif entry_map["lang"].startswith("scala") and entry_map["kind"] == "import":
            build_file_contents += _SCALA_IMPORT_TEMPLATE.format(name = name, exports=exports_str, jars=jars_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        elif entry_map["lang"].startswith("scala") and entry_map["kind"] == "library":
            build_file_contents += _SCALA_LIBRARY_TEMPLATE.format(name = name, exports=exports_str, runtime_deps=runtime_deps_str, visibility=entry_map["visibility"])
        else:
            print(entry_map)

      ctx.file(ctx.path(key + "/BUILD"), build_file_contents, False)
    return None

build_external_workspace_from_opts = repository_rule(
    attrs = {
        "target_configs": attr.string_list_dict(mandatory = True),
        "separator": attr.string(mandatory = True),
        "build_header": attr.string(mandatory = True),
    },
    implementation = _build_external_workspace_from_opts_impl
)




def build_header():
 return """load("@io_bazel_rules_scala//scala:scala_import.bzl", "scala_import")
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library")"""

def list_target_data_separator():
 return "|||"

def list_target_data():
    return {
"3rdparty/jvm/org/scala_lang:scala_compiler": ["lang||||||scala/unmangled:2.12.10","name||||||//3rdparty/jvm/org/scala_lang:scala_compiler","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||@io_bazel_rules_scala_scala_compiler//:io_bazel_rules_scala_scala_compiler","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang:scala_library": ["lang||||||scala/unmangled:2.12.10","name||||||//3rdparty/jvm/org/scala_lang:scala_library","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||@io_bazel_rules_scala_scala_library//:io_bazel_rules_scala_scala_library","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang:scala_reflect": ["lang||||||scala/unmangled:2.12.10","name||||||//3rdparty/jvm/org/scala_lang:scala_reflect","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||@io_bazel_rules_scala_scala_reflect//:io_bazel_rules_scala_scala_reflect","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/com/github/scopt:scopt": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/com/github/scopt:scopt","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/com/github/scopt/scopt_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/circe:circe_core": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/io/circe:circe_core","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/io/circe/circe_core_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/typelevel:cats_core|||//3rdparty/jvm/io/circe:circe_numbers","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/circe:circe_derivation": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/io/circe:circe_derivation","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/io/circe/circe_derivation_2_12","sources|||L|||","exports|||L|||//3rdparty/jvm/io/circe:circe_core|||//3rdparty/jvm/org/typelevel:cats_core|||//3rdparty/jvm/org/typelevel:cats_kernel","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/circe:circe_jawn": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/io/circe:circe_jawn","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||import","deps|||L|||","jars|||L|||//external:jar/io/circe/circe_jawn_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/io/circe:circe_core|||//3rdparty/jvm/org/typelevel:jawn_parser","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/circe:circe_numbers": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/io/circe:circe_numbers","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||import","deps|||L|||","jars|||L|||//external:jar/io/circe/circe_numbers_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/io/circe:circe_parser": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/io/circe:circe_parser","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/io/circe/circe_parser_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/io/circe:circe_jawn|||//3rdparty/jvm/io/circe:circe_core","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang/modules:scala_parser_combinators": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/org/scala_lang/modules:scala_parser_combinators","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||@io_bazel_rules_scala_scala_parser_combinators//:io_bazel_rules_scala_scala_parser_combinators","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/scala_lang/modules:scala_xml": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/org/scala_lang/modules:scala_xml","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||library","deps|||L|||","jars|||L|||","sources|||L|||","exports|||L|||@io_bazel_rules_scala_scala_xml//:io_bazel_rules_scala_scala_xml","runtimeDeps|||L|||","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/typelevel:cats_core": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/org/typelevel:cats_core","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/org/typelevel/cats_core_2_12","sources|||L|||","exports|||L|||//3rdparty/jvm/org/typelevel:cats_kernel|||//3rdparty/jvm/org/typelevel:cats_macros|||//3rdparty/jvm/org/typelevel:machinist","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/typelevel:cats_kernel": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/org/typelevel:cats_kernel","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/org/typelevel/cats_kernel_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/typelevel:cats_macros": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/org/typelevel:cats_macros","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/org/typelevel/cats_macros_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/typelevel:jawn_parser": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/org/typelevel:jawn_parser","visibility||||||//3rdparty/jvm:__subpackages__","kind||||||import","deps|||L|||","jars|||L|||//external:jar/org/typelevel/jawn_parser_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/typelevel:machinist": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/org/typelevel:machinist","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/org/typelevel/machinist_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library|||//3rdparty/jvm/org/scala_lang:scala_reflect","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"],
"3rdparty/jvm/org/typelevel:paiges_core": ["lang||||||scala:2.12.10","name||||||//3rdparty/jvm/org/typelevel:paiges_core","visibility||||||//visibility:public","kind||||||import","deps|||L|||","jars|||L|||//external:jar/org/typelevel/paiges_core_2_12","sources|||L|||","exports|||L|||","runtimeDeps|||L|||//3rdparty/jvm/org/scala_lang:scala_library","processorClasses|||L|||","generatesApi|||B|||false","licenses|||L|||","generateNeverlink|||B|||false"]
 }


def build_external_workspace(name):
  return build_external_workspace_from_opts(name = name, target_configs = list_target_data(), separator = list_target_data_separator(), build_header = build_header())

