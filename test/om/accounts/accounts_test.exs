defmodule Om.AccountsTest do
  use Om.DataCase

  alias Om.Accounts

  describe "videos" do
    alias Om.Accounts.Video

    @valid_attrs %{description: "some description", title: "some title", url: "some url"}
    @update_attrs %{description: "some updated description", title: "some updated title", url: "some updated url"}
    @invalid_attrs %{description: nil, title: nil, url: nil}

    def video_fixture(attrs \\ %{}) do
      {:ok, video} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_video()

      video
    end

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Accounts.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Accounts.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      assert {:ok, %Video{} = video} = Accounts.create_video(@valid_attrs)
      assert video.description == "some description"
      assert video.title == "some title"
      assert video.url == "some url"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      assert {:ok, video} = Accounts.update_video(video, @update_attrs)
      assert %Video{} = video
      assert video.description == "some updated description"
      assert video.title == "some updated title"
      assert video.url == "some updated url"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_video(video, @invalid_attrs)
      assert video == Accounts.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Accounts.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Accounts.change_video(video)
    end
  end

  describe "categories" do
    alias Om.Accounts.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Accounts.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Accounts.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Accounts.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Accounts.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_category(category, @invalid_attrs)
      assert category == Accounts.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Accounts.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Accounts.change_category(category)
    end
  end
end
