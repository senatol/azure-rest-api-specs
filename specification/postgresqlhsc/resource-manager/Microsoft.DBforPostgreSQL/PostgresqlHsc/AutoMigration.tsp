import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "./Cluster.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Versioning;

namespace Microsoft.DBforPostgreSQL;

/**
 * Represents the auto migration of a cluster to an Azure Database for PostgreSQL elastic cluster. Each cluster has a single auto migration named default.
 */
@added(Versions.v2026_02_06_preview)
@singleton("default")
@parentResource(Cluster)
model AutoMigration
  is Azure.ResourceManager.ProxyResource<AutoMigrationProperties> {
  ...ResourceNameParameter<
    Resource = AutoMigration,
    KeyName = "autoMigrationName",
    SegmentName = "autoMigrations",
    NamePattern = "^default$"
  >;
}

/** The properties of the auto migration of a cluster. */
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "The service manages this singleton and has only a synchronous PATCH and no PUT, so there is no long-running provisioning to report; state reports the migration progress."
@added(Versions.v2026_02_06_preview)
model AutoMigrationProperties {
  /** The state of the auto migration. */
  @visibility(Lifecycle.Read)
  state?: AutoMigrationState;

  /** Indicates whether auto migration is enabled for the cluster. */
  mode?: AutoMigrationMode;

  /** The time in UTC when the auto migration is scheduled to start. */
  scheduledStartTime?: utcDateTime;

  /** Indicates whether the auto migration can still be rescheduled or opted out of. */
  @visibility(Lifecycle.Read)
  canRescheduleOrCancel?: boolean;

  /** The time window the auto migration can be rescheduled to. Only returned when the migration can be rescheduled. */
  @visibility(Lifecycle.Read)
  rescheduleWindow?: AutoMigrationRescheduleWindow;
}

/** Represents the auto migration properties that can be updated. */
@added(Versions.v2026_02_06_preview)
model AutoMigrationForUpdate {
  /** The properties of the auto migration that can be updated. */
  properties?: AutoMigrationPropertiesForUpdate;
}

/** The properties of the auto migration of a cluster that can be updated. */
@added(Versions.v2026_02_06_preview)
model AutoMigrationPropertiesForUpdate {
  /** Set to Disabled to cancel the auto migration and opt the cluster out of auto migration. Opting out is permanent; a cluster that has opted out cannot be set back to Enabled. Cannot be set to Disabled together with scheduledStartTime. */
  mode?: AutoMigrationMode;

  /** The time when the auto migration should start. Must be within the reschedule window. */
  scheduledStartTime?: utcDateTime;
}

/** Indicates whether auto migration is enabled for the cluster. */
@added(Versions.v2026_02_06_preview)
union AutoMigrationMode {
  string,

  /** Auto migration is enabled for the cluster. */
  Enabled: "Enabled",

  /** The cluster is opted out of auto migration. */
  Disabled: "Disabled",
}

/** The time window the auto migration can be rescheduled to. */
@added(Versions.v2026_02_06_preview)
model AutoMigrationRescheduleWindow {
  /** The earliest time in UTC the auto migration can be rescheduled to. */
  @visibility(Lifecycle.Read)
  earliestStartTime?: utcDateTime;

  /** The latest time in UTC the auto migration can be rescheduled to. */
  @visibility(Lifecycle.Read)
  latestStartTime?: utcDateTime;
}

/** The state of the auto migration. */
@added(Versions.v2026_02_06_preview)
union AutoMigrationState {
  string,

  /** No auto migration is scheduled for the cluster. */
  NotScheduled: "NotScheduled",

  /** An auto migration is scheduled for the cluster. */
  Scheduled: "Scheduled",

  /** The auto migration is in progress. */
  InProgress: "InProgress",

  /** The auto migration completed successfully. */
  Succeeded: "Succeeded",

  /** The auto migration failed. */
  Failed: "Failed",

  /** The auto migration was canceled. */
  Canceled: "Canceled",
}

/** Operations for the auto migration of a cluster. */
@armResourceOperations
@added(Versions.v2026_02_06_preview)
interface AutoMigrations {
  /** Gets the auto migration of the cluster. */
  get is ArmResourceRead<AutoMigration>;

  /** Lists the auto migration of the cluster. The list contains a single item named default. */
  listByCluster is ArmResourceListByParent<AutoMigration>;

  /** Reschedules the auto migration of the cluster, or opts the cluster out of auto migration by setting mode to Disabled. */
  update is ArmCustomPatchSync<AutoMigration, AutoMigrationForUpdate>;
}

@@doc(
  AutoMigrations.update::parameters.properties,
  "The parameters for rescheduling the auto migration or opting the cluster out of auto migration."
);
@@doc(AutoMigration.name, "The name of the auto migration. Must be default.");
