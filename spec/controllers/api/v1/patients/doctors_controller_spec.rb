require 'spec_helper'

describe Api::V1::Patients::DoctorsController do
  render_views
  let(:patient)      { FactoryGirl.create(:patient) }
  let(:clinic)       { FactoryGirl.create(:clinic) }
  let(:clinic2)      { FactoryGirl.create(:clinic)}
  let(:department)   { FactoryGirl.create(:department) }
  let(:department2)  { FactoryGirl.create(:department, name: 'Genetics') }
  let(:department3)  { FactoryGirl.create(:department, clinic_id: 2) }
  let(:doctor)       { FactoryGirl.create(:doctor) }
  let(:doctor2)      { FactoryGirl.create(:doctor, email: 'doc2@doc.com') }
  let(:doctor3)      { FactoryGirl.create(:doctor, email: 'doc3@doc.com', clinic_id: 2) }
  let(:doctor4)      { FactoryGirl.create(:doctor, email: 'doc4@doc.com', department_id: 2)}
  before :each do
    patient.save
    clinic.save
    clinic2.save
    department.save
    department2.save
    department3.save
    doctor.save
    doctor2.save
    doctor3.save
    doctor4.save
    @token = 'ca76c7a6c7a'
    patient.update_attribute(:api_key, encrypt(@token))
  end
  context :json do
    describe 'GET department_index' do
      it 'should have failed response with no api token' do
        get :department_index, format: 'json'
        expect(response).not_to be_success
        response.status.should == 401
        expect(json['success']).to eq false
      end
      it 'should have failed response with invalid api token' do
        config = { format: 'json', api_token: 123 }
        get :department_index, config
        expect(response).not_to be_success
        response.status.should == 401
        expect(json['success']).to eq false
      end
      it 'should return a list of departments in clinic with valid api token' do
        config = { format: 'json', api_token: @token }
        get :department_index, config
        expect(response).to be_success
        response.status.should == 200
        expect(json['data']['departments']).not_to be_nil
        expect(json['data']['departments'].find { |dept| dept['id'] == department.id}).to_not be_nil
        expect(json['data']['departments'].find { |dept| dept['id'] == department2.id}).to_not be_nil
        expect(json['data']['departments'].find { |dept| dept['id'] == department3.id}).to be_nil
      end
    end

    describe 'GET #index' do
      it 'should have failed response with no api token' do
        config = { format: 'json', name: department.name }
        get :index, config
        expect(response).not_to be_success
        response.status.should == 401
        expect(json['success']).to eq false
      end
      it 'should have failed response with invalid api token' do
        config = { format: 'json', api_token: 123, name: department.name }
        get :index, config
        expect(response).not_to be_success
        response.status.should == 401
        expect(json['success']).to eq false
      end
      it 'should return doctors in same department within same clinic' do
        config = { format: 'json', api_token: @token, name: department.name }
        get :index, config
        expect(response).to be_success
        expect(json['data']['doctors'].find { |doc| doc['id'] == doctor.id  }).not_to be_nil
        expect(json['data']['doctors'].find { |doc| doc['id'] == doctor2.id }).not_to be_nil
        expect(json['data']['doctors'].find { |doc| doc['id'] == doctor3.id }).to be_nil
        expect(json['data']['doctors'].find { |doc| doc['id'] == doctor4.id }).to be_nil
      end
    end
  end
end