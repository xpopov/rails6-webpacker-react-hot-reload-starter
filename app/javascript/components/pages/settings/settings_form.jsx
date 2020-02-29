import React, { Component, Fragment, useState } from 'react'
import { Mutation, Query } from 'react-apollo'
import { Button, Col, Form, Row, Spinner, Toast } from 'react-bootstrap'
import { withRouter } from 'react-router-dom'
import { useForm, Controller } from 'react-hook-form'
import createApp from '@shopify/app-bridge';
import { Heading } from '@shopify/polaris'
import { isEmpty } from "lodash"

import { useFlashMessage } from '../../utilities/flash'

import { listSettings } from '../../../graphql/queries'
import { updateSettings } from '../../../graphql/mutations'

const config = require("json-loader!yaml-loader!../../../../../config/shopify_api.yml")
const currentConfig = config[process.env.NODE_ENV]

const SettingsForm = (props) => {
  // console.log(props);
  const actionSuccessMessage = 'Settings saved';
  const { handleSubmit, control, errors, register, reset } = useForm({
  });
  const app = createApp(currentConfig);
  const toastOptions = {
    message: actionSuccessMessage,
    duration: 5000,
  }
  const [flashShow, setFlashShow] = useState(false);
  const { createFlashMessage } = useFlashMessage(app, toastOptions, setFlashShow);

  const onSubmitCompleted = () => {
    createFlashMessage();
  }

  const onSubmit = mutation => {
    return data => {
      console.log(errors);
      console.log(data);
      if (isEmpty(errors) && data) {
        console.log(mutation);
        var formatted = data;
        // formatted["price"] = parseFloat(data.price);
        // formatted["pageCount"] = data.pageCount === "" ? null : parseInt(data.pageCount);
        console.log(formatted);
        mutation({ variables: formatted });
      }
    }
  }

  return (
    <Query query={listSettings}>
    {({ data, loading, error }) => {
      if (loading) return (
        <Fragment>
          <Spinner animation="border" role="status">
            <span className="sr-only">Loading...</span>
          </Spinner>
        </Fragment>
      );
      if (error) return <div>{error.message}</div>;
      console.log(errors);
      const settings = data.settings;
      console.log(settings);
      return (
        <>
          <Toast onClose={() => setFlashShow(false)} show={flashShow} delay={3000} autohide
            animation
            style={{
              position: 'absolute',
              top: 0,
              right: 0,
              marginRight: '8px',
              marginTop: '5px'
            }}
          >
            <Toast.Header>
              <strong className="mr-auto">Notification</strong>
            </Toast.Header>
            <Toast.Body>{actionSuccessMessage}</Toast.Body>
          </Toast>
          <Mutation 
            mutation={updateSettings}
            onCompleted={onSubmitCompleted}
            variables={settings}
          >
            {(doUpdateSettings, { loading, error: mutationError }) =>
              <Form noValidate validated={true} 
                onSubmit={handleSubmit(onSubmit(doUpdateSettings))}
                style={{position: "relative"}}
              >
                {
                  mutationError && <>
                    <Heading>{mutationError.toString()}</Heading>
                  </>
                }
                <Form.Row>
                  <Form.Group as={Col} md="6" controlId="companyName">
                    <Form.Label>Company Name</Form.Label>
                    <Controller as={<Form.Control />} name="companyName" control={control}
                      rules={{ required: true }}
                      required
                      type="text"
                      placeholder=""
                      defaultValue={settings.companyName || ""}
                    />
                    {
                      errors.companyName ?
                      <Form.Control.Feedback type={"invalid"}>Please fill the field!</Form.Control.Feedback>
                      : ""
                    }
                  </Form.Group>
                  <Form.Group as={Col} md="6" controlId="identity">
                    <Form.Label>Identity</Form.Label>
                    <Controller as={<Form.Control />} name="identity" control={control}
                      rules={{ required: true }}
                      required
                      type="text"
                      placeholder=""
                      defaultValue={settings.identity || ""}
                    />
                    {
                      errors.identity ?
                      <Form.Control.Feedback type={"invalid"}>Please fill the field!</Form.Control.Feedback>
                      : ""
                    }
                  </Form.Group>
                </Form.Row>
                <Form.Row>
                  <Form.Group as={Col} md="12" controlId="notificationEmails">
                    <Form.Label>Emails for notifications</Form.Label>
                    <Controller as={<Form.Control />} name="notificationEmails" control={control}
                      rules={{ required: true }}
                      required
                      type="text"
                      placeholder=""
                      defaultValue={settings.notificationEmails || ""}
                    />
                    {
                      errors.notificationEmails ?
                      <Form.Control.Feedback type={"invalid"}>Please fill the field!</Form.Control.Feedback>
                      : ""
                    }
                  </Form.Group>
                </Form.Row>
                <Button type="submit">Update</Button>
              </Form>
            }
          </Mutation>
        </>
      );
    }}
    </Query>
  );
}

export default withRouter(SettingsForm)
