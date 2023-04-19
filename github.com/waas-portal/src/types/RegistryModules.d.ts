// Copied from '@octokit/rest'
export interface RegistryModules {
  data: Array<{
    id: string;
    type: string;
    attributes: {
      name: string;
      namespace: string;
      provider: string;
      status: string;
      version_statuses: Array<{
        version: string;
        status: string;
      }>;
      created_at: string;
      updated_at: string;
      registry_name: string;
      vcs_repo: {
        branch: string;
        ingress_submodules: boolean;
        identifier: string;
        display_identifier: string;
        respository_http_url: string;
        service_provider: string;
      };
    };
  }>;
}
