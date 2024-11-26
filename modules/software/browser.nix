{...}: {

  # configure firefox
  programs.firefox = {
    enable = true;

    languagePacks = ["en-US" "de"];

    policies = let
      lock-false = {
        Value = false;
        Status = "locked";
      };
    in {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never";
      HttpsOnlyMode = "enabled";
      PostQuantumKeyAgreementEnabled = true;
      TranslateEnabled = false;

      # default extensions
      ExtensionSettings = {
        # Privacy Badger:
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };

        # # AdNauseam
        "adnauseam@rednoise.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
          installation_mode = "force_installed";
        };

        # KeepassXC-Browser
        "keepassxc-browser@keepassxc.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          installation_mode = "force_installed";
        };

        # Startpage Plugin
        "{20fc2e06-e3e4-4b2b-812b-ab431220cada}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/startpage-private-search/latest.xpi";
          installation_mode = "force_installed";
        };

        # Disable all default search engine add-ons
        "amazon@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "bing@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "ebay@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "ecosia@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "google@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "leo_ende_de@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "wikipedia@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "duckduckgo@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
      };

      Preferences = {
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "extensions.pocket.enabled" = lock-false;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };
    };
  };
}
