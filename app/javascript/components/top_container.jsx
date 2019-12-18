import { hot } from 'react-hot-loader/root'
import { Container, Row, Col } from 'react-bootstrap'

import React from 'react'
import Hello from './hello_view'

const TopContainer = () => (
  <Container>
    <Row className="align-items-center justify-content-center">
      <Col className="col-sm-12 text-center">
        <Hello name="React" />
      </Col>
    </Row>
  </Container>
)

export default hot(TopContainer)
