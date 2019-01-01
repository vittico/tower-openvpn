tower-cli config host https://tower.etalesystems.com
tower-cli config username admin
tower-cli config password 7BZq0dTclOy21sYEFVwvJfjLafjr


tower-cli receive --all > assets.json
tower-cli receive --credential all --organization all --user all --team all > credentials.json
