defmodule Core.Monitoring.StatusTest do
  use Core.DataCase

  describe "Status" do
    alias Core.{
      Monitoring,
      Monitoring.Status
    }

    @valid_attrs %{
      active: true,
      description: "some text",
      status_code: 1,
      status_name: "status #1"
    }

    @invalid_attrs %{
      active: nil,
      status_name: nil,
      status_code: nil
    }

    test "list_status/0 with empty list" do
      data = Monitoring.list_status()
      assert data == []
      assert Enum.empty?(data) == true
    end

    test "list_status/0 with data" do
      status = insert(:status)
      data =
        Monitoring.list_status()
      assert data == [status]
      assert Enum.count(data) == 1
    end

    test "create_status/1" do
      assert {:ok, %Status{} = created} = Monitoring.create_status(@valid_attrs)
      assert created.active      == @valid_attrs.active
      assert created.description == @valid_attrs.description
      assert created.status_code == @valid_attrs.status_code
      assert created.status_name == @valid_attrs.status_name
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_status(@invalid_attrs)
    end

    test "get_status/1" do
      status = insert(:status)
      struct = Monitoring.get_status(status.id)
      assert struct.id          == status.id
      assert struct.active      == status.active
      assert struct.description == status.description
      assert struct.status_code == status.status_code
      assert struct.status_name == status.status_name
    end

    test "get_status/1 with invalid id returns error changeset" do
      status_id = FlakeId.get()
      assert {:error, %Ecto.Changeset{}} = Monitoring.get_status(status_id)
    end
  end
end
