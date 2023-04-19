// Copied from '@octokit/rest'
export interface RegistryModule {
  id: string;
  name: string;
  namespace: string;
  provider: string;
  description: string;
  root: {
    inputs: Array<{
      name: string;
      type: string;
      description: string;
      default: string;
      required: bolean;
      value: string;
    }>;
  };
}
