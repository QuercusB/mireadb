CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "courses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "code" varchar(255), "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "task_lists" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "index" integer DEFAULT 0, "name" varchar(255), "course_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "students" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "login" varchar(255), "created_at" datetime, "updated_at" datetime, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255));
CREATE TABLE "student_assignments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "student_id" integer, "task_variant_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_student_assignments_on_student_id" ON "student_assignments" ("student_id");
CREATE INDEX "index_student_assignments_on_task_variant_id" ON "student_assignments" ("task_variant_id");
CREATE TABLE "student_task_attempts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "student_id" integer, "task_id" integer, "done" boolean DEFAULT 'f', "error_message" varchar(255), "type" varchar(255), "data" text, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_student_task_attempts_on_student_id" ON "student_task_attempts" ("student_id");
CREATE INDEX "index_student_task_attempts_on_task_id" ON "student_task_attempts" ("task_id");
CREATE TABLE "tasks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "task_list_id" integer, "task_variant_id" integer, "index" integer DEFAULT 0, "type" varchar(255), "subject" text, "created_at" datetime, "updated_at" datetime, "data" text, "title" varchar(255));
CREATE INDEX "index_tasks_on_task_list_id" ON "tasks" ("task_list_id");
CREATE INDEX "index_tasks_on_task_variant_id" ON "tasks" ("task_variant_id");
CREATE TABLE "task_variants" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "index" integer DEFAULT 0, "description" text, "course_id" integer, "created_at" datetime, "updated_at" datetime, "type" varchar(255), "data" text);
CREATE VIEW student_tasks AS    
			SELECT
				task_list.id as task_list_id,
				student_assignment.student_id as student_id,
				task.id as task_id,
				MAX(attempt.done) as done
			FROM
				task_lists task_list
				JOIN courses course
					ON course.id = task_list.course_id
				JOIN task_variants variant
					ON variant.course_id = course.id
				JOIN student_assignments student_assignment
					ON student_assignment.task_variant_id = variant.id
				JOIN tasks task
					ON task.task_list_id = task_list.id AND task.task_variant_id = variant.id
				LEFT JOIN student_task_attempts attempt
				    ON attempt.task_id = task.id and attempt.student_id = student_assignment.student_id
			GROUP BY task_list.id, student_assignment.student_id, task.id;
CREATE UNIQUE INDEX "index_students_on_login" ON "students" ("login");
INSERT INTO schema_migrations (version) VALUES ('20140924021219');

INSERT INTO schema_migrations (version) VALUES ('20140924022759');

INSERT INTO schema_migrations (version) VALUES ('20140925022705');

INSERT INTO schema_migrations (version) VALUES ('20140930065221');

INSERT INTO schema_migrations (version) VALUES ('20140930071138');

INSERT INTO schema_migrations (version) VALUES ('20140930085858');

INSERT INTO schema_migrations (version) VALUES ('20141006145456');

INSERT INTO schema_migrations (version) VALUES ('20141006153154');

INSERT INTO schema_migrations (version) VALUES ('20141006154116');

INSERT INTO schema_migrations (version) VALUES ('20141006164218');

INSERT INTO schema_migrations (version) VALUES ('20141006164645');

INSERT INTO schema_migrations (version) VALUES ('20141006165602');

INSERT INTO schema_migrations (version) VALUES ('20141006165903');

INSERT INTO schema_migrations (version) VALUES ('20141006172053');

INSERT INTO schema_migrations (version) VALUES ('20141006172506');

INSERT INTO schema_migrations (version) VALUES ('20141006173412');

INSERT INTO schema_migrations (version) VALUES ('20141007061403');

INSERT INTO schema_migrations (version) VALUES ('20141012103333');

INSERT INTO schema_migrations (version) VALUES ('20141016123920');

INSERT INTO schema_migrations (version) VALUES ('20141020070230');

INSERT INTO schema_migrations (version) VALUES ('20141021070732');

INSERT INTO schema_migrations (version) VALUES ('20141022084801');

INSERT INTO schema_migrations (version) VALUES ('20141022111424');

INSERT INTO schema_migrations (version) VALUES ('20141022163254');

