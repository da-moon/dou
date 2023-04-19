import { ThemeState } from 'styles/theme/slice/types';
import { ModuleRegistryFormStateState } from 'app/pages/RegistryList/slice/types';
import { ModuleInputsState } from 'app/pages/ModuleInputs/slice/types';
import { ConfirmationStateState } from 'app/pages/Confirmation/slice/types';
// [IMPORT NEW CONTAINERSTATE ABOVE] < Needed for generating containers seamlessly

/* 
  Because the redux-injectors injects your reducers asynchronously somewhere in your code
  You have to declare them here manually
  Properties are optional because they are injected when the components are mounted sometime in your application's life. 
  So, not available always
*/
export interface RootState {
  theme?: ThemeState;
  moduleRegistryFormState?: ModuleRegistryFormStateState;
  moduleInputs?: ModuleInputsState;
  confirmationState?: ConfirmationStateState;
  // [INSERT NEW REDUCER KEY ABOVE] < Needed for generating containers seamlessly
}
