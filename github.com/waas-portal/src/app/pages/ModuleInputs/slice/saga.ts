import { call, put, select, takeLatest } from 'redux-saga/effects';
import { request } from 'utils/request';
import { moduleInputsActions as actions } from '.';
import { RegistryModule } from 'types/RegistryModule';
import { ModuleRegistryErrorType } from './types';
import {
  selectModuleName,
  selectModuleVersion,
  selectModuleProvider,
} from '../../RegistryList/slice/selectors';

export function* moduleInputsSaga() {
  const module_name: string = yield select(selectModuleName);
  const module_version: string = yield select(selectModuleVersion);
  const module_provider: string = yield select(selectModuleProvider);
  const requestURL = `${process.env.REACT_APP_GOWRAPPER_HOST}/organization/${process.env.REACT_APP_GOWRAPPER_ORG}/${module_name}/${module_provider}/${module_version}`;
  try {
    // Call our request helper (see 'utils/request')
    const result = yield call(request, requestURL);
    const registry_module: RegistryModule = result;
    if (registry_module.root.inputs?.length > 0) {
      const inputs = Object.assign([], registry_module.root.inputs).map(obj =>
        Object.assign({}, obj, { value: '' }),
      );
      registry_module.root.inputs = inputs;
      const input = registry_module.root.inputs.map(obj =>
        Object.assign({}, obj, { value: '' }));
      yield put(actions.registryInputsLoaded(input));
    }
    yield put(actions.registryModuleLoaded(registry_module));
  } catch (err) {
    yield put(
      actions.registryModuleError(ModuleRegistryErrorType.RESPONSE_ERROR),
    );
  }
}

export function* moduleInputsStateSaga() {
  yield takeLatest(actions.loadRegistryModule.type, moduleInputsSaga);
}
