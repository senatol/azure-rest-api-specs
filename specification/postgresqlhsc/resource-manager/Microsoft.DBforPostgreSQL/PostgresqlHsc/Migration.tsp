import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/versioning";

using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;

namespace Microsoft.DBforPostgreSQL;

/**
 * Request to migrate the cluster to an Azure Database for PostgreSQL elastic cluster.
 */
@added(Versions.v2026_02_06_preview)
model MigrateRequest {
  /** The properties of the migration request. */
  properties: MigrateRequestProperties;
}

/** The properties of a request to migrate the cluster. */
@added(Versions.v2026_02_06_preview)
model MigrateRequestProperties {
  /** The resource ID of the target Azure Database for PostgreSQL elastic cluster. */
  targetResourceId: armResourceIdentifier<[
    {
      type: "Microsoft.DBforPostgreSQL/flexibleServers";
    }
  ]>;

  /** Indicates whether the migration should wait for high availability to be provisioned on the target before completing. */
  waitHa?: boolean;

  /** Indicates whether the migration is a dry run. A dry run leaves the source cluster writable and does not finalize the target. */
  dryRun?: boolean;
}

/**
 * Represents the migration of a cluster to an Azure Database for PostgreSQL elastic cluster.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "Preserve ProxyResource allOf inheritance in the service contract."
@added(Versions.v2026_02_06_preview)
model Migration extends Azure.ResourceManager.CommonTypes.ProxyResource {
  /** The properties of the migration. */
  properties?: MigrationProperties;
}

/** The properties of the migration of a cluster. */
@added(Versions.v2026_02_06_preview)
model MigrationProperties {
  /** The name of the target elastic cluster. */
  @visibility(Lifecycle.Read)
  flexName?: string;

  /** The resource group of the target elastic cluster. */
  @visibility(Lifecycle.Read)
  flexResourceGroup?: string;

  /** The subscription of the target elastic cluster. */
  @visibility(Lifecycle.Read)
  flexSubscription?: string;

  /** Indicates whether the migration waits for high availability to be provisioned on the target. */
  @visibility(Lifecycle.Read)
  waitHa?: boolean;

  /** Provisioning state of the migration. */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/** The result of checking whether the cluster can be migrated. */
@added(Versions.v2026_02_06_preview)
model MigrationValidityResult {
  /** Indicates whether the cluster can be migrated. */
  validated: boolean;

  /** The reason the cluster cannot be migrated. Not returned when the cluster can be migrated. */
  message?: string;
}
