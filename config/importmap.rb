# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "chartkick" # @5.0.1
pin "Chart.bundle", to: "Chart.bundle.js"
pin "chart.js" # @4.2.1
pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.2
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
