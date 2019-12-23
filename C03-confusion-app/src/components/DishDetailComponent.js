import React, { Component } from 'react';
import { Card, CardImg, CardText, CardBody, CardTitle, Breadcrumb, BreadcrumbItem, Button, Modal, ModalHeader, ModalBody, Row, Label, Col } from 'reactstrap';
import { Link } from 'react-router-dom';
import { Control, LocalForm, Errors } from 'react-redux-form';
import { Loading } from  './LoadingComponent';
import { baseUrl } from '../shared/baseUrl';
import { FadeTransform, Fade, Stagger} from 'react-animation-components';

const maxLength = (len) => (val) => !(val) || (val.length <= len);
const minLength = (len) => (val) => val && (val.length >= len);

function RenderDish({ dish }){
  return(
    <FadeTransform in
      transformProps={{
        exitTransform: 'scale(0.5) translateY(-50%)'
      }}
      >
      <Card>
        <CardImg width="100%" src={baseUrl + dish.image} alt={dish.name} />
        <CardBody>
          <CardTitle>{dish.name}</CardTitle>
          <CardText>{dish.description}</CardText>
        </CardBody>
      </Card>
    </FadeTransform>
  );
}
  
function RenderComments({ comments, postComment, dishId }){
  return(
    <ul className="list-unstyled">
      <Stagger in>
        {
          comments.map((comment) => 
            (
            <Fade in>
              <li key={comment.id}>
                <p>{comment.comment}</p>
                <p>-- {comment.author} , {new Intl.DateTimeFormat('en-US', { year: 'numeric', month: 'short', day: '2-digit'}).format(new Date(Date.parse(comment.date)))}</p>
              </li>
            </Fade>
            )
          )
        }
        <CommentForm dishId={ dishId } postComment={ postComment } />
      </Stagger>
    </ul>
  );
}


const DishDetail = (props) => {
  if(props.isLoading){
    return (
      <div className="container">
        <div className="row">
          <Loading />
        </div>
      </div>
    );
  }
  else if(props.errMess){
    return (
      <div className="container">
        <div className="row">
          <h4>{ props.errMess }</h4>
        </div>
      </div>
    );
  }
  else if(props.dish != null){
    return(
      <div className="container">
        <div className="row">
          <Breadcrumb>
            <BreadcrumbItem>
              <Link to='/menu'>Menu</Link>
            </BreadcrumbItem>
            <BreadcrumbItem active>{ props.dish.name }</BreadcrumbItem>
          </Breadcrumb>
          <div className="col-12">
            <h3>{ props.dish.name }</h3>
            <hr />
          </div>
        </div>
        <div className="row">
          <div className="col-12 col-md-5 m-1">
            <RenderDish dish={props.dish}/>
          </div>
          
          <div className="col-12 col-md-5 m-1">
            <h4>Comments</h4>
            <RenderComments comments={ props.comments }
              postComment={ props.postComment }
              dishId={ props.dish.id }
              />
          </div>
        </div>
      </div>
    );
  }
  else{
    return(
      <div></div>
    );
  }
};

class CommentForm extends Component{
  
  constructor(props){
    super(props);
    this.state = {
      isModalOpen: false
    };
    
    this.toggleModal = this.toggleModal.bind(this);
    this.handleCommentSubmit = this.handleCommentSubmit.bind(this);
  }
  
  toggleModal(){
    this.setState({
      isModalOpen: !this.state.isModalOpen
    });
  }
  
  handleCommentSubmit(values){
    this.toggleModal();
    this.props.postComment(this.props.dishId, values.rating, values.author, values.comment);
    // console.log("Current State is: " + JSON.stringify(values));
    // alert("Current State is: " + JSON.stringify(values));
  }
  
  render(){
    return(
      <div>
        <Button outline color="secondary" onClick={this.toggleModal}><i className="fa fa-pencil fa-lg"></i> Submit Comment</Button>
        
        <Modal isOpen={this.state.isModalOpen} toggle={this.toggleModal}>
          <ModalHeader toggle={this.toggleModal}>Submit Comment</ModalHeader>
          <ModalBody>
            <LocalForm onSubmit={ (values) => this.handleCommentSubmit(values) }>
              
              <Row className="form-group">
                <Label htmlFor="rating" md={12}>Rating</Label><br />
                <Col md={12}>
                  <Control.select model=".rating" className="form-control" id="rating" name="rating">
                    <option value="1" default>1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                  </Control.select>
                </Col>
              </Row>
            
              <Row className="form-group">
                <Label htmlFor="author" md={12}>Your Name</Label><br />
                <Col md={12}>
                  <Control.text model=".author" className="form-control" id="author" name="author" placeholder="Your Name" 
                    validators={{
                      minLength: minLength(3), maxLength: maxLength(15)
                    }}
                  />
                  <Errors
                    className="text-danger"
                    model=".author"
                    show="touched"
                    messages={{ // show this if something is false in above
                      minLength: 'Must be greater than 2 characters',
                      maxLength: 'Must be 15 characters or less'
                    }}
                    />
                </Col>
              </Row>
              
              <Row className="form-group">
                <Label htmlFor="comment" md={12}>Comment</Label>
                <Col md={12}>
                  <Control.textarea model=".comment" rows="6" id="comment" name="comment" className="form-control" />
                </Col>
              </Row>
              
              <Row className="form-group">
                <Col >
                  <Button type="submit" color="primary">Submit</Button>
                </Col>
              </Row>
              
            </LocalForm>
          </ModalBody>
        </Modal>
      </div>
    );
  }
};

export default DishDetail;