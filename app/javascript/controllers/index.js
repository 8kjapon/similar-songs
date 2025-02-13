// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import AutocompleteController from "./autocomplete_controller"
application.register("autocomplete", AutocompleteController)

import SearchAutocompleteController from "stimulus-autocomplete";
application.register("search-autocomplete", SearchAutocompleteController);

import ArtistAutocompleteController from "stimulus-autocomplete";
application.register("artist-autocomplete", ArtistAutocompleteController);

import MediaController from "./media_controller"
application.register("media", MediaController)

import MultiStepFormController from "./multi_step_form_controller"
application.register("multi-step-form", MultiStepFormController)

