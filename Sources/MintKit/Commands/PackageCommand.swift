import Foundation
import Utility
import PathKit

class PackageCommand: MintCommand {

    var verboseArgument: OptionArgument<Bool>!
    var packageArgument: PositionalArgument<String>!

    override init(mint: Mint, parser: ArgumentParser, name: String, description: String) {
        super.init(mint: mint, parser: parser, name: name, description: description)

        let packageHelp = """
        The identifier for the Swift Package to use. It can be a shorthand for a github repo \"githubName/repo\", or a fully qualified .git path.
        An optional version can be specified by appending @version to the repo, otherwise the newest tag will be used (or master if no tags are found)
        """
        packageArgument = subparser.add(positional: "package", kind: String.self, optional: false, usage: packageHelp)
        verboseArgument = subparser.add(option: "--verbose", kind: Bool.self, usage: "Show installation output")
    }

    override func execute(parsedArguments: ArgumentParser.Result) throws {
        try super.execute(parsedArguments: parsedArguments)
        let verbose = parsedArguments.get(verboseArgument) ?? false
        let package = parsedArguments.get(packageArgument)!

        var mintPackage = MintPackage(package: package)
      
        if mintPackage.version.isEmpty, let mintfile = Mintfile.default() {
          // set version to version from mintfile
          if let version = mintfile.version(for: mintPackage.repo), !version.isEmpty {
            mintPackage = MintPackage(version: version, repo: mintPackage.repo)
            print("🌱  Using \"\(mintPackage.repo)\" \"\(mintPackage.version)\" from Mintfile.")
          }
        }

        try execute(parsedArguments: parsedArguments, repo: mintPackage.repo, version: mintPackage.version, verbose: verbose)
    }

    func execute(parsedArguments: ArgumentParser.Result, repo: String, version: String, verbose: Bool) throws {
    }
}
