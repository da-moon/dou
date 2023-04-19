import { RegistryModules } from 'types/RegistryModules';

/* --- STATE --- */
export interface ModuleRegistryFormStateState {
  loading: boolean;
  filter: string[];
  error?: ModuleRegistryErrorType | null;
  registry_modules: RegistryModules;
  module_name: String;
  module_version: String;
  module_provider: String;
  module_spw_url: String;
  module_spw_provider: String;
}

export enum ModuleRegistryErrorType {
  RESPONSE_ERROR = 1,
  HAS_NO_REGISTRY_MODULES = 2,
}

export type ContainerState = ModuleRegistryFormStateState;
