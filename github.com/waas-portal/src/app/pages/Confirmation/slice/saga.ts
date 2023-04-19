import { call, select, takeLatest, put } from 'redux-saga/effects';
import { request } from 'utils/request';
import { confirmationStateActions as actions } from '.';
import {
  selectModuleNamespace,
  selectInputs,
} from '../../ModuleInputs/slice/selectors';
import {
  selectModuleSpwUrl,
  selectModuleSpwProvider,
} from '../../RegistryList/slice/selectors';
import { selectWorkspace } from './selectors';
import { DeployErrorType } from './types';

export function* airflowPayloadCallSaga() {
  const requestURL = `${process.env.REACT_APP_AIRFLOWHOST}/api/experimental/dags/waas_portal/dag_runs`;
  const namespace: string = yield select(selectModuleNamespace);
  const inputs: any[] = yield select(selectInputs);
  const workspace: string = yield select(selectWorkspace);
  const spw_url: string = yield select(selectModuleSpwUrl);
  const spw_provider: string = yield select(selectModuleSpwProvider);
  let newInputs = inputs.map(function (item) {
    let obj = { ...item };
    delete obj.default;
    return obj;
  });
  const arrayToObject = <T extends Record<K, any>, K extends keyof any>(
    array: T[] = [],
    getKey: (item: T) => K,
  ) =>
    array.reduce((obj, cur) => {
      const key = getKey(cur);
      return { ...obj, [key]: cur };
    }, {} as Record<K, T>);
  try {
    yield call(request, requestURL, {
      method: 'POST',
      mode: 'no-cors',
      cache: 'no-cache',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        conf: {
          terraform: {
            organization: process.env.REACT_APP_GOWRAPPER_ORG,
            workspace: {
              name: workspace,
            },
            spw: {
              source: spw_url.split('/')[1],
            },
            inputs: arrayToObject(newInputs, item => item.name),
            env_inputs: {},
          },
          github: {
            repo_name: workspace,
          },
        },
      }),
    });
  } catch (err) {}
  yield put(actions.changeDeployStatus(true));
}

export function* confirmationStateSaga() {
  yield takeLatest(actions.createService.type, airflowPayloadCallSaga);
}
