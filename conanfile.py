from conans import ConanFile, tools
import os
import json

class QuickPromiseConan(ConanFile):
    name = "quickpromise"
    version = "1.0.8"
    license = "Apache 2.0"
    url = "https://github.com/benlau/quickpromise"
    description = "Promise library for QML"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = "shared=False"
    exports = "qconanextra.json"
    exports_sources = "*.pro", "*.pri", "*.js", "*.h" , "*.cpp", "*.qml", "!tests/*", "*/qmldir", "*.qrc"

    def build(self):
        args = []
        if self.options.shared:
            args.append("CONFIG+=no_staticlib");
            
        qmake = "qmake %s/lib/lib.pro %s" % (self.source_folder, " ".join(args));
        self.run(qmake)
        self.run("make")

    def package(self):
        self.copy("*.a", dst="lib", keep_path=False)
        self.copy("*.dylib", dst="lib", keep_path=False)
        self.copy("*.dll", dst="lib", keep_path=False)
        self.copy("*", src="qml/QuickPromise", dst="qml/QuickPromise", keep_path=True)

        qconanextra_json = {}
        qconanextra_json["resource"] = "quickpromise"

        with open(os.path.join(self.package_folder, "qconanextra.json"), "w") as file:
            file.write(json.dumps(qconanextra_json))
            file.close()

    def package_info(self):
        self.cpp_info.libs = ["quickpromise"]
