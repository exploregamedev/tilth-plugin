tool

extends Node

signal project_loaded(project)
signal project_saved(project)
signal project_deleted(project_id)
signal project_created(project)
signal project_selected(project)
signal project_state_changed(project)


signal ui_added_stage(stage)
signal ui_deleted_stage(stage)

signal ui_deleted_stage_task(stage)
signal ui_updated_task(task)


signal ui_added_task_activity(activity_entry)

signal app_settings_changed()

signal ui_reorded_project_stages(project)
signal ui_reorded_stage_tasks(stage)


