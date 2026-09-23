# TODO

## Remove Isar (isar / isar_flutter_libs / isar_generator)

Isar 3.x is **abandoned** (unmaintained since 2023). Its Android Gradle files
predate AGP 8, which breaks Android builds. We currently rely on a Gradle
workaround (see below) that must NOT be kept long term.

### Current workaround (to delete after migration)

`android/build.gradle.kts` contains a `subprojects { afterEvaluate { ... } }`
block that injects a `namespace` and bumps `compileSdk` for legacy plugins
(i.e. `isar_flutter_libs`). Remove it once Isar is gone.

Related temporary-ish config: `flutter_local_notifications` required core
library desugaring in `android/app/build.gradle.kts`, and the `health` plugin
forced `minSdk` to 26 (Android 8.0+). Those are fine to keep.

### Proposed solutions

1. **Switch to the `isar_community` fork** (lowest effort, keeps the API)
   - Drop-in maintained fork of Isar 3.x, compatible with modern AGP/Gradle.
   - pubspec: `isar` -> `isar_community`, `isar_flutter_libs` -> `isar_community_flutter_libs`,
     `isar_generator` -> `isar_community_generator` (same versions, same API).
   - Update imports in `lib/`, delete generated `*.g.dart`, re-run `build_runner`.
   - The `.isar` database file stays compatible (same engine version).
   - Effort: ~1-2 h. Risk: low. Still on a community-maintained fork.

2. **Migrate the whole data layer to `drift` (or `sqflite`)** (cleanest long term)
   - `sqflite` is already used in the app (`lib/services/sqflite_food_service.dart`).
   - Rewrite models (Exercise, WorkoutProgram, ScheduledWorkout, ExerciseHistory,
     PersonalRecord, BodyMeasurement, Nutrition*) as tables/DTOs.
   - Rewrite all queries in `lib/services/database_service.dart`,
     `backup_service.dart`, `nutrition_service.dart`,
     `lib/providers/scheduled_workout_provider.dart`.
   - Requires a data migration path for existing user DBs (export/import via
     backup JSON as a bridge).
   - Effort: multi-day refactor. Risk: medium (data migration).

3. **Alternative NoSQL stores** (objectbox, hive_ce, sembast) — only worth it
   if we want to stay schema-less; still requires rewriting models + queries,
   so option 1 or 2 is preferable.

### Recommendation

Do **1** now to unblock Android, then plan **2** as a proper refactor.

## Full import/export backup

The current backup (`lib/services/backup_service.dart`, exposed in
`lib/screens/settings_screen.dart`) only covers exercises, programs,
sessions, histories and personal records. It is **incomplete** — the
following data is neither exported nor restored:

- Body measurements (`bodyMeasurements`)
- Workouts collection (`workouts`)
- Nutrition data (goals, daily logs, meal entries)
- The separate sqflite food DB (custom foods / favorites,
  `lib/services/sqflite_food_service.dart`)

### What to do

- Extend the backup format (bump `'version'` to 4) to include all the
  collections above, while remaining backward compatible when importing
  version 1-3 files (sections are already optional in `importFromJSON`).
- Include the sqflite food DB in the export (e.g. as a JSON table dump) or
  switch it to the same store as everything else — see the Isar/drift
  migration above.
- Consider a "restore replaces everything" mode (wipe + import) vs the
  current upsert behavior, so restoring on a fresh device yields an exact
  copy.
- Keep this usable as the migration bridge if we later switch storage
  engine (option 2 above): export with the old app version -> import with
  the new one.
