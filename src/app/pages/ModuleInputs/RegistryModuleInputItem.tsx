/* eslint-disable no-restricted-globals */
import * as React from 'react';
import styled from 'styled-components/macro';
import { Form, Row } from 'react-bootstrap';

export function RegistryModuleInputItem({
  keyVal,
  input,
  onChangeModuleInput,
}) {
  return (
    <ModuleInputsRow key={keyVal}>
      <InputNameRow>
        <InputName>{input.name}</InputName>
        <InputRequired>{input.required ? 'REQUIRED' : ''}</InputRequired>
        <InputDescription>{input.description}</InputDescription>
        <FormInput
          type="text"
          placeholder={input.default}
          defaultValue={input.value}
          onChange={e => onChangeModuleInput(e, keyVal, input)}
        />
      </InputNameRow>
    </ModuleInputsRow>
  );
}

const ModuleInputsRow = styled(Row)`
  &:last-child {
    margin-bottom: 0;
  }
  margin-bottom: 1rem;
  border-radius: 2px;
  box-shadow: 0 0 0 1px #bac1cc;
  background-color: #f7f8fa;
`;

const InputNameRow = styled(Row)`
  padding: 1.5rem;
  margin: 0;
`;

const InputName = styled.span`
  color: #525761;
  font-size: 1.286rem;
  font-weight: 400;
  line-height: 1.25;
  margin: 0;
  display: inline-block;
  width: auto;
  padding: 0;
`;

const InputRequired = styled.span`
  color: #626873;
  cursor: pointer;
  text-decoration: none;
  display: inline-block;
  font-weight: 700;
  font-size: 0.8571428571rem;
  text-transform: uppercase;
  width: auto;
  margin-left: 5rem;
`;

const FormInput = styled(Form.Control)`
  margin-top: 1rem;
`;

const InputDescription = styled.p`
  color: #525761;
  font-weight: 400;
  font-size: 1rem;
  line-height: 1.5;
  margin-bottom: 0;
  padding: 0;
`;
