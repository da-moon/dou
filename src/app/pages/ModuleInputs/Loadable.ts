/**
 *
 * Asynchronously loads the component for ModuleInputs
 *
 */

import { lazyLoad } from 'utils/loadable';

export const ModuleInputs = lazyLoad(
  () => import('./index'),
  module => module.ModuleInputs,
);
