require 'rails_helper'

RSpec.describe "Tickets API", type: :request do
  let(:user)    { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:state)   { FactoryGirl.create(:state, name: "Open") }
  let!(:ticket) do
    FactoryGirl.create(:ticket, project: project, state: state)
  end

  before do
    assign_role!(user, :manager, project)
    user.generate_api_key
  end

  context "as an authenticated user" do
    let(:headers) do
      { "HTTP_AUTHORIZATION" => "Token token=#{user.api_key}" }
    end

    it "retrieves a ticket's information" do
      get api_project_ticket_path(project, ticket),
        params: { format: :json }, headers: headers

      expect(response.status).to eq 200

      json = ActiveModelSerializers::SerializableResource.new(ticket, adapter: :json).to_json

      expect(response.body).to eq json
    end

    it "can create a ticket" do
      params = {
        format: "json",
        ticket: {
          name: "Test Ticket",
          description: "Just checking things out."
        }
      }

      post api_project_tickets_path(project), params: params, headers: headers
      expect(response.status).to eq 201

      json = ActiveModelSerializers::SerializableResource.new(Ticket.last, adapter: :json).to_json
      expect(response.body).to eq json
    end

    it "cannot create a ticket with invalid data" do
      params = {
        format: "json",
        ticket: {
          name: "",
          description: ""
        }
      }

      post api_project_tickets_path(project), params: params, headers: headers

      expect(response.status).to eq 422
      json = {
        "errors" => [
          "Name can't be blank",
          "Description can't be blank",
          "Description is too short (minimum is 10 characters)"
        ]
      }
      expect(JSON.parse(response.body)).to eq json
    end

    it 'can update a ticket' do
      patch api_project_ticket_path(project, ticket), params: { ticket: { name: "Add RWD" } },
        headers: headers
      expect(response.status).to eq 204

      expect(Ticket.find(ticket.id).name).to eq "Add RWD"
    end

    it "cannot update a ticket with invalid data" do
      params = {
        format: "json",
        ticket: {
          name: "",
          description: ""
        }
      }

      patch api_project_ticket_path(project, ticket), params: params, headers: headers

      expect(response.status).to eq 422
      json = {
        "errors" => [
          "Name can't be blank",
          "Description can't be blank",
          "Description is too short (minimum is 10 characters)"
        ]
      }
      expect(JSON.parse(response.body)).to eq json
    end

    it 'can delete a ticket' do
      puts project.tickets.count
      expect do
        delete api_project_ticket_path(project, ticket), params: { format: :json },
          headers: headers
      end.to change(project.tickets, :count).by(-1)

      expect(response.status).to eq 204
    end

    context "without permission to view the project" do
      before do
        user.roles.delete_all
      end

      it 'responds with a 403' do
        get api_project_ticket_path(project, ticket, format: :json),
          params: {}, headers: headers
        expect(response.status).to eq 403
        error = { "error" => "Unauthorized" }
        expect(JSON.parse(response.body)).to eq error
      end
    end
  end

  context "as an unauthenticated user" do
    it 'responds with 401' do
      get api_project_ticket_path(project, ticket, format: :json)
      expect(response.status).to eq 401
      error = { "error" => "Unauthorized" }
      expect(JSON.parse(response.body)).to eq error
    end
  end
end
