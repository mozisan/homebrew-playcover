class PlayCoverNightlyDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    page = ::Utils::Curl.curl_output("--fail", "--location", url).stdout
    artifact_url = page[/href="([^"]+\.dmg\.zip)"/, 1]
    raise CurlDownloadStrategyError.new(url, "Nightly artifact URL was not found") if artifact_url.nil?

    super(artifact_url, name, version, **meta)
  end
end

cask "playcover-nightly" do
  version :latest
  sha256 :no_check

  url "https://nightly.link/playcover/playcover/workflows/2.nightly_release/develop",
      using: PlayCoverNightlyDownloadStrategy
  name "PlayCover"
  desc "Sideload iOS apps and games"
  homepage "https://github.com/PlayCover/PlayCover"

  auto_updates true
  conflicts_with cask: "playcover-community"
  depends_on arch: :arm64
  depends_on macos: :monterey

  app "PlayCover.app"

  zap trash: [
    "~/Library/Application Support/io.playcover.PlayCover",
    "~/Library/Caches/io.playcover.PlayCover",
    "~/Library/Containers/io.playcover.PlayCover",
    "~/Library/Frameworks/PlayTools.framework",
    "~/Library/Preferences/io.playcover.PlayCover.plist",
    "~/Library/Saved Application State/io.playcover.PlayCover.savedState",
  ]
end
