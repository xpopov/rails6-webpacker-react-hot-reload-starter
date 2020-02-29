import React from 'react'
import { Container, Row, Col } from 'react-bootstrap'

export default (Children) => {
  return () => (
    <Container>
      <Row className="align-items-center justify-content-center">
        <Col className="col-sm-12 text-center">
          {/* <TitleBar /> */}
          <Children />
          {/* <Hello name="React" /> */}
        </Col>
      </Row>
    </Container>
  )
}
