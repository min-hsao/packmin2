import { application } from "./application"

// Eager load all controllers
import PackingFormController from "./packing_form_controller"
application.register("packing-form", PackingFormController)
