using {
    md,
    td,
    view
} from '../db/schema';

service northwind {

    entity Products          as
        select from view.Products {
            Id,
            Name                        @mandatory,
            Description                 @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Rating,
            Price                       @mandatory,
            case
                when
                    Price >= 10.00
                then
                    3
                else
                    1
            end             as IsReleaseDateEnabled : Integer,
            Height,
            Width,
            Depth,
            Quantity                    @(
                mandatory,
                assert.range : [
                    0.00,
                    20.00
                ]
            ),
            ToUnitOfMeasure             @mandatory,
            ToCurrency                  @mandatory,
            ToCategory                  @mandatory,
            ToCategory.Name as Category @readonly,
            ToDimensionUnit,
            ToSalesData,
            ToStockAvailability,
            StockAvailability,
            ToSupplier,
            ToReviews
        };

    @readonly
    entity Suppliers         as
        select from md.Suppliers {
            Id,
            Name,
            Email,
            Phone,
            Fax,
            ToProduct
        };

    entity Reviews           as
        select from td.ProductReviews {
            Id,
            Name    @mandatory,
            Rating,
            Comment @mandatory,
            CreatedAt,
            ToProduct
        };

    @readonly
    entity SalesData         as
        select from td.SalesData {
            Id,
            DeliveryDate,
            Revenue,
            ToCurrency.Id               as CurrencyKey,
            ToDeliveryMonth.Id          as DeliveryMonthId,
            ToDeliveryMonth.Description as DeliveryMonth,
            ToProduct
        };

    @readonly
    entity StockAvailability as
        select from md.StockAvailability {
            Id,
            Description,
            ToProduct
        };

    @readonly
    entity VH_Categories     as
        select from md.Categories {
            Id   as Code,
            Name as Text
        };

    @readonly
    entity VH_Currencies     as
        select from md.Currencies {
            Id          as Code,
            Description as Text
        };

    @readonly
    entity VH_UnitOfMeasures as
        select from md.UnitOfMeasures {
            Id          as Code,
            Description as Text
        };

    @readonly
    entity VH_DimensionUnits as
        select from md.DimensionUnits {
            Id          as Code,
            Description as Text
        };

    type Parameter {
        KeyName : String;
    }

    type Action {
        Id                 : String;
        Name               : String;
        Config             : {
            SemanticObject : String;
            Action         : String;
            Parameters     : array of Parameter;
        };
    }

    type ConfigData {
        Id      : String;
        Actions : array of Action;
    }

    function GetData() returns ConfigData;
}
