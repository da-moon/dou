/**
 *
 * ModuleInputs
 *
 */
import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import styled from 'styled-components/macro';
import { Container, Row, Col, Button } from 'react-bootstrap';
import { useModuleInputsSlice } from './slice';
import { selectModuleRegistry, selectInputs } from './slice/selectors';
import { RegistryModuleInputItem } from './RegistryModuleInputItem';
import { selectModulesRegistry } from '../RegistryList/slice/selectors';
import { useHistory } from 'react-router-dom';

export function ModuleInputs() {
  const registryModule = useSelector(selectModuleRegistry);
  const registryModules = useSelector(selectModulesRegistry);
  const inputs = useSelector(selectInputs);

  const { actions } = useModuleInputsSlice();

  const dispatch = useDispatch();

  const history = useHistory();

  const useEffectOnMount = (effect: React.EffectCallback) => {
    // eslint-disable-next-line react-hooks/exhaustive-deps
    useEffect(effect, []);
  };

  useEffectOnMount(() => {
    if (registryModules.data?.length === 0) history.push('/');
    else dispatch(actions.loadRegistryModule());
  });

  const onChangeModuleInput = (
    evt: React.ChangeEvent<HTMLInputElement>,
    input_index,
    input,
  ) => {
    let newInputs = inputs.map((obj, index) => {
      if (index === input_index)
        return Object.assign({}, obj, { value: evt.target.value });
      return obj;
    });
    dispatch(actions.registryInputsLoaded(newInputs));
  };

  const goToConfirmation = () => {
    history.push('/confirmation');
  };

  return (
    <MainContainer>
      <HeaderRow>
        <Title>{'Modules'}</Title>
        <ButtonCreate onClick={goToConfirmation}>{'Next >>'}</ButtonCreate>
      </HeaderRow>
      <RegistrySectionRow>
        <CustomCol md="3">
          <ModuleContainer>
            <SubTitle>{'Selected Module'}</SubTitle>
            <ModuleRow>
              <ModuleName>{registryModule.name}</ModuleName>
              <ModuleDescription>
                {registryModule.description}
              </ModuleDescription>
              <ModuleInfo>{'Private'}</ModuleInfo>
              <ModuleInfo>{registryModule.provider}</ModuleInfo>
              <ModuleInfo>{registryModule.id.split('/').pop()}</ModuleInfo>
            </ModuleRow>
          </ModuleContainer>
        </CustomCol>
        <CustomCol md="9">
          <ModulesInputsContainer>
            <SubTitle>{'Configure Variables for'}</SubTitle>
            {registryModule.root.inputs?.length > 0
              ? registryModule.root.inputs.map((registryModuleInput, index) => (
                  <RegistryModuleInputItem
                    keyVal={index}
                    input={registryModuleInput}
                    onChangeModuleInput={onChangeModuleInput}
                  />
                ))
              : null}
          </ModulesInputsContainer>
        </CustomCol>
      </RegistrySectionRow>
    </MainContainer>
  );
}

const MainContainer = styled(Container)`
  padding: 0;
`;

const ModuleContainer = styled(Container)`
  padding: 1.5rem;
  min-height: 250px;
`;

const ModulesInputsContainer = styled(Container)`
  padding: 1.5rem;
  border-left: 1px solid #dce0e6;
  min-height: 250px;
`;

const CustomCol = styled(Col)`
  margin: 0;
  padding: 0;
`;

const SubTitle = styled.p`
  color: #000;
  font-size: 1.286rem;
  font-weight: 600;
  line-height: 1.5;
  margin-top: 0;
`;

const RegistrySectionRow = styled(Row)`
  border: 1px solid #dce0e6;
`;

const HeaderRow = styled(Row)`
  padding: 1.5rem 0;
  margin: 0;
  position: relative;
`;

const Title = styled.h2`
  font-size: 1.286rem !important;
  font-weight: 600;
  color: #000;
  width: auto;
  padding: 5px 0 0 0;
`;

const ButtonCreate = styled(Button)`
  &:hover {
    background-color: #33c440;
    border-color: #23882c;
    opacity: 1;
    text-decoration: underline;
  }
  position: absolute;
  right: 0;
  border-color: #23882c;
  background-color: #2eb039;
  color: #ecf7ed;
  font-size: 1rem;
  font-weight: 700;
  width: 250px;
  height: 40px;
  border-radius: 2px;
  cursor: pointer;
  box-shadow: 0 3px 1px rgb(111 118 130 / 20%);
`;

const ModuleRow = styled(Row)`
  &:last-child {
    margin-bottom: 0;
  }
  margin: 0;
  border: 0.0625rem solid #5c4ee5;
  background-color: #f7f8fa;
  box-shadow: 0 0.125rem 0.1875rem 0 rgb(0 0 0 / 8%);
  border-radius: 0.375rem;
  margin-bottom: 1rem;
  overflow: hidden;
  padding: 1.5rem;
  position: relative;
  width: 100%;
`;

const ModuleName = styled.p`
  color: #1f2124;
  font-size: 1rem;
  font-weight: 700;
  line-height: 1.5;
  margin: 0;
`;

const ModuleDescription = styled.p`
  color: #1f2124;
  margin-top: 1rem;
  font-size: 1rem;
  line-height: 1.5;
`;

const ModuleInfo = styled.span`
  color: #6f7682;
  line-height: 1.5;
  width: auto;
`;

