import React, { Component, Fragment, useState } from 'react'
import { Mutation, Query } from 'react-apollo'
import { Button, Col, Form, Row, Spinner, Toast } from 'react-bootstrap'
import { withRouter } from 'react-router-dom'
import { useForm, Controller } from 'react-hook-form'
import createApp from '@shopify/app-bridge';
import { Heading } from '@shopify/polaris'
import { isEmpty } from "lodash"

import { useFlashMessage } from '../../utilities/flash'

import { listProductVariants } from '../../../graphql/queries'
import { createClient, updateClient } from '../../../graphql/mutations'
import { client, listClients } from '../../../graphql/queries'

const config = require("json-loader!yaml-loader!../../../../../config/shopify_api.yml")
const currentConfig = config[process.env.NODE_ENV]

const ClientForm = (props) => {
  // console.log(props);
  const formType = props.type;
  const actionSuccessMessage = formType == "new" ? 'Client created' : 'Client saved';
  const { handleSubmit, control, errors, register, reset } = useForm({
    // reValidateMode: 'onChange'
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
    setTimeout(() => { props.history.push('/clients') }, 
      2000
    );
  }

  const onSubmit = mutation => {
    return data => {
      console.log(errors);
      console.log(data);
      if (isEmpty(errors) && data) {
        // variables = { id: }
        console.log(mutation);
        var formatted = data;
        formatted["price"] = parseFloat(data.price);
        formatted["pageCount"] = data.pageCount === "" ? null : parseInt(data.pageCount);
        console.log(formatted);
        mutation({ variables: formatted });
      }
    }
  }

  return (
    <Query query={listProductVariants}>
    {({ data, loading, error }) => {
      if (loading) return (
        <Fragment>
          <Spinner animation="border" role="status">
            <span className="sr-only">Loading...</span>
          </Spinner>
        </Fragment>
      );
      if (error) return <div>{error.message}</div>;
      console.log(data);
      console.log(errors);
      const shopify_variant_options = (
        <>
          <option value="">Choose...</option>
          {
            data.productVariants.map(v => (
              <option key={v.id} value={v.id}>{v.title + ", SKU=" + v.sku}</option>
            ))
          }
        </>
      );
      const validated_shopify_variant_id = 
        data.productVariants.filter(v => v.id == props.client.shopifyVariantId).length > 0 ?
        props.client.shopifyVariantId.toString() : "";
      console.log(validated_shopify_variant_id);
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
            mutation={formType == "new" ? createClient : updateClient}
            refetchQueries={
              formType == "new" ?
                [
                  { query: listClients, variables: {} }
                ] :
                [
                  { query: client, variables: { id: props.client.id } }
                ]
            }
            onCompleted={onSubmitCompleted}
            variables={props.client}
          >
            {(doUpdateClient, { loading, error: mutationError }) =>
              <Form noValidate validated={true} 
                onSubmit={handleSubmit(onSubmit(doUpdateClient))}
                style={{position: "relative"}}
              >
                {
                  mutationError && <>
                    <Heading>{mutationError.toString()}</Heading>
                  </>
                }
                <Form.Row>
                  <Form.Group as={Col} md="6" controlId="firstName">
                    <Form.Label>First Name</Form.Label>
                    <Controller as={<Form.Control />} name="firstName" control={control}
                      rules={{ required: true }}
                      required
                      type="text"
                      placeholder=""
                      defaultValue={props.client.firstName}
                    />
                    {
                      errors.firstName ?
                      <Form.Control.Feedback type={"invalid"}>Please fill the field!</Form.Control.Feedback>
                      : ""
                    }
                  </Form.Group>
                  <Form.Group as={Col} md="6" controlId="lastName">
                    <Form.Label>Last Name</Form.Label>
                    <Controller as={<Form.Control />} name="lastName" control={control}
                      rules={{ required: true }}
                      required
                      type="text"
                      placeholder=""
                      defaultValue={props.client.lastName}
                    />
                    {
                      errors.lastName ?
                      <Form.Control.Feedback type={"invalid"}>Please fill the field!</Form.Control.Feedback>
                      : ""
                    }
                  </Form.Group>
                </Form.Row>
                <Button type="submit">{formType == "new" ? "Create" : "Save"}</Button>
              </Form>
            }
          </Mutation>
        </>
      );
    }}
    </Query>
  );
}

export default withRouter(ClientForm)
