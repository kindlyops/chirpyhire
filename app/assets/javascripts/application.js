// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

// BEGIN VENDOR JS FOR PAGES (plus add in jquery.turbolinks)
//= require jquery
//= require jquery_ujs
//= require pages-plugins/modernizr.custom
//= require bootstrap-sprockets
//= require pages-plugins/jquery/jquery-easy
//= require pages-plugins/jquery-unveil/jquery.unveil.min
//= require pages-plugins/jquery-bez/jquery.bez.min
//= require pages-plugins/jquery-ios-list/jquery.ioslist.min
//= require pages-plugins/imagesloaded/imagesloaded.pkgd.min
//= require pages-plugins/jquery-actual/jquery.actual.min
//= require pages-plugins/jquery-scrollbar/jquery.scrollbar.min
//= require pages-plugins/bootstrap-select2/select2.min.js
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

// BEGIN CORE TEMPLATE JS FOR PAGES
//= require pages-core/js/pages

// BEGIN SITE SCRIPTS

//= require indexTable
//= require clickTable
//= require select
//= require user

//  I prefer to list scripts in a specific order, so I comment out require_tree .
// require_tree .
//= require turbolinks
